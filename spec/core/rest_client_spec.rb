require "rspec"
require_relative "../helpers/response_helper"
require_relative "../../lib/core/rest_client"

include ResponseHelper

describe RestClient do
  let(:rest_client) { RestClient }
  let(:json_response) { json("response.json") }
  let(:text_response) { text("response.json") }
  let(:xml_response) { xml("response.xml") }
  let(:html_response) { html("response.html") }
  let(:csv_response) { csv("response.csv") }

  let(:response) { double("response", code: "200", body: text_response) }

  describe "#get" do
    subject { rest_client.get(uri) }
    context "given an unparseable uri" do
      unparseable_uris = [nil, {}, [], "", " ", "a"]

      unparseable_uris.each do |u|
        context "when uri '#{u.class}'" do
          let(:uri) { u }
          it { expect { subject }.to raise_error("'#{u}' is not a valid URI") }
        end
      end
    end

    context "given a url which returns a redirect" do
      let(:uri) { "http://newurl.com" }
      let(:redirect_uri) { "http://www.newurl.com" }

      let(:redirect) do
        double("response", code: "301", body: nil, header: { "location" => redirect_uri })
      end

      before do
        allow(Net::HTTP).to receive(:get_response).with(URI.parse(uri)).and_return(redirect)
        allow(Net::HTTP).to receive(:get_response)
          .with(URI.parse(redirect_uri)).and_return(response)
      end

      it "returns the page from the redirect url" do
        expect(subject).to_not be_empty
      end
    end

    context "given no connection to the server" do
      let(:uri) { "http://foo" }

      before do
        allow(Net::HTTP).to receive(:get_response).with(URI.parse(uri))
          .and_raise(SocketError, "getaddrinfo: nodename nor servname provided, or not known")
      end

      it "returns descriptive error" do
        error_message = "Can't connect to 'http://foo', check your connected to a network."
        expect { subject }.to raise_error(error_message)
      end
    end

    context "given a json response" do
      let(:uri) { "http://json" }

      before do
        allow(Net::HTTP).to receive(:get_response).with(URI.parse(uri)).and_return(response)
      end

      context "when using default options" do
        it "returns a json object" do
          expect(subject).to eq(json_response)
        end
      end

      context "when using 'json' options" do
        subject { rest_client.get(uri, as: :json) }

        it "returns a json object" do
          expect(subject).to eq(json_response)
        end
      end

      context "when using 'text' options" do
        subject { rest_client.get(uri, as: :text) }

        it "returns plain text" do
          expect(subject).to eq(text_response)
          expect(subject).not_to eq(json_response)
        end
      end
    end

    context "given an xml response" do
      subject { rest_client.get(uri, as: :xml) }

      let(:uri) { "http://xml" }
      let(:text_response) { text("response.xml") }
      let(:response) { double("response", code: "200", body: text_response) }

      before do
        allow(Net::HTTP).to receive(:get_response).with(URI.parse(uri)).and_return(response)
      end

      context "when using the 'xml' option" do
        it "returns an xml document" do
          expect(subject.to_xml).to eq(xml_response.to_xml)
        end
      end
    end

    context "given an html response" do
      subject { rest_client.get(uri, as: :html) }

      let(:uri) { "http://html" }
      let(:text_response) { text("response.html") }
      let(:response) { double("response", code: "200", body: text_response) }

      before do
        allow(Net::HTTP).to receive(:get_response).with(URI.parse(uri)).and_return(response)
      end

      context "when using the 'html' option" do
        it "returns an html document" do
          expect(subject.to_xml).to eq(html_response.to_xml)
        end
      end
    end

    context "given a csv response" do
      subject { rest_client.get(uri, as: :csv) }

      let(:uri) { "http://csv" }
      let(:text_response) { text("response.csv") }
      let(:response) { double("response", code: "200", body: text_response) }

      before do
        allow(Net::HTTP).to receive(:get_response).with(URI.parse(uri)).and_return(response)
      end

      context "when using the 'csv' option" do
        it "return a two dimensional array" do
          expect(subject).to eq(csv_response)
        end
      end
    end
  end
end
