
function assertEqualsString()
{
	local expected="${1}"
	local actual="${2}"
	local message="${3:-Unknown}"

	local exitCode=0
	test "${expected}" == "${actual}" || exitCode=$?

	if [[ ${exitCode} -ne 0 ]]; then
		echo 1>&2 "Failed asserting that two strings are equal - ${message}"
		echo 1>&2 '--- EXPECTED BEGIN ---'
		echo 1>&2 "${expected}"
		echo 1>&2 '--- EXPECTED END   ---'

		echo 1>&2 '--- ACTUAL BEGIN ---'
		echo 1>&2 "${actual}"
		echo 1>&2 '--- ACTUAL END   ---'

		echo 1>&2 '--- DIFF COLOR BEGIN ---'
		diff --context=3 --color=always <(echo "${expected}" ) <(echo "${actual}") 2>&2 || true
		echo 1>&2 '--- DIFF COLOR END   ---'

		echo 1>&2 '--- DIFF SPACE BEGIN ---'
		diff --context=3 <(echo "${expected}" ) <(echo "${actual}") 2>&2 | cat -A || true
		echo 1>&2 '--- DIFF SPACE END   ---'
	fi

	return ${exitCode}
}

function assertEqualsNumber()
{
	local expected=${1}
	local actual=${2}
	local message="${3:-Unknown}"

	local exitCode=0
	test "${expected}" -eq "${actual}" || exitCode=$?

	if [[ ${exitCode} -ne 0 ]]; then
		echo 1>&2 "Failed asserting that two numbers are equal - '${expected}' == '${actual}' ${message}"
	fi

	return ${exitCode}
}

function assertPregMatch()
{
	local pattern="${1:?Required}"
	local subject="${2}"
	local message="${3:-Unknown}"

	local exitCode=0
	[[ "${subject}" =~ ${pattern} ]] || exitCode=$?

	if [[ ${exitCode} -ne 0 ]]; then
		echo 1>&2 "Failed asserting that pattern '${pattern}' matches to subject '${subject}' - ${message}"
	fi

	return ${exitCode}
}
