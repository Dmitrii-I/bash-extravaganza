#!/bin/bash

# Bash library containing generic functions


timestamp() {
	date +"%Y-%m-%d %H:%M:%S.%N"
}

is_login_shell() {
	if shopt -q login_shell; then echo TRUE
	else echo FALSE; fi
}
