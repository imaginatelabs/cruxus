# Useful Rspec testing helpers
module Helper
  def capture(stream)
    # rubocop:disable all
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
  # rubocop:enable all
    result
  end
end
