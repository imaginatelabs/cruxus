echo "Message to stdout"
>&2 echo "Message to stderr"
echo "Type a greeting"
read greeting
echo "Type your name"
read name
echo "$greeting $name"
echo "Type an exitcode"
read exitcode
echo "Program exiting with exitcode $exitcode"
exit $exitcode