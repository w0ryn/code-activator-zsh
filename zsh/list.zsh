_CA_GET_LIST() {
	echo "clone new $(_CA_LIST)" | sed 's/ /\n/g'
}
