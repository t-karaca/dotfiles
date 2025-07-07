timezsh() {
	shell=${1-$SHELL}
	for i in $(seq 1 10); do time $shell -i -c exit; done
}

zshclearcompletions() {
	rm -f "${ZSH}/cache/.zcompdump"
	rm -f "${ZSH}/cache/.zcompdump.zwc"
	zshreload
}

