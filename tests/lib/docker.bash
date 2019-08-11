
function dockerRun()
{
	local dstVarName="${1}"
	shift
	local -n result=${dstVarName}
	local tmpStdOutput=$(mktemp)
	local tmpStdError=$(mktemp)

	result[exitCode]=0
	docker run --rm -t "${imageID}" "${@}" 1>"${tmpStdOutput}" 2>"${tmpStdError}" || result[exitCode]=$?
	result[stdOutput]=$(cat "${tmpStdOutput}" | sed --expression='s/\r//g')
	result[stdError]=$(cat "${tmpStdError}" | sed --expression='s/\r//g')

	rm -rf "${tmpStdOutput}" "${tmpStdError}"
}
