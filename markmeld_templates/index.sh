x=`find * -type f -name "*.jinja"`

echo "{"
for i in $x; do
	echo "    \"${i%.jinja}\": \"$i\","
done
echo "}"
