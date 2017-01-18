#!/bin/bash
# Checks HTTP status codes for various API endpoints.

# Provides a simple example of how to use cURL to check the status codes of HTTP calls
# and make assertions against API calls to REST / HTTP endpoints.

# Also convenient to schedule script as cron tab to run regression tests.

chromeHeaders="Chrome"
fireFoxHeaders="FireFox"

baseUrl="http://www.test.com:8181"
cookiesFile="cookies.txt"
cookieOptions="--cookie $cookiesFile --cookie-jar $cookiesFile"
curlOptions="--write-out %{http_code} --silent --output /dev/null"
recipientEmail="test@example.com"

# Status test
statusTest() {
    path="status"
    response=$(curl -A "$chromeHeaders" $curlOptions $cookieOptions "$baseUrl/$path")
    assertSuccess $response $path
    sleep 1
}

# Login test
loginTest() {
    path="login"
    response=$(curl -A "$chromeHeaders" $curlOptions $cookieOptions -F "username=test1" -F "password=start123" "$baseUrl/$path")
    assertSuccess $response $path
    sleep 1
}

# Secure test
secureTest() {
    path="secure"
    response=$(curl -A "$chromeHeaders" $curlOptions $cookieOptions "$baseUrl/$path")
    assertSuccess $response $path
    sleep 1
}

# AJAX test
ajaxTest() {
    path="ajax"
    response=$(curl -A "$chromeHeaders" $curlOptions $cookieOptions "$baseUrl/$path")
    assertSuccess $response $path
    sleep 1
}

dataTest() {
    path="data"
    response=$(curl -A "$chromeHeaders" -F "id=$1" $curlOptions $cookieOptions "$baseUrl/$path")
    assertSuccess $response $path
    sleep 1
}

# Swaps networks via OpenVPN
swapNetwork() {
    echo "⚙ ⚙ ⚙ ⚙  Swapping Network  ⚙ ⚙ ⚙ ⚙"
    sleep 1
}

# Asserts we received a 200 response code
assertSuccess() {

    if [ "$1" -eq 200 ]; then
        handleSuccess "$2"
    else
        handleFailure "$2 test response code: [$1]"
    fi
}

# Asserts we DID NOT receive a 200 response code
assertFailure() {

    if [ "$1" -ne 200 ]; then
        handleSuccess "$2"
    else
        handleFailure "$2 test response code: [$1]"
    fi
}

# Handle Success cases
handleSuccess() {
    # Send an alert email
    echo "🐳 🐳 🐳 🐳  $1 test success 🐳 🐳 🐳 🐳"
}

# Failure Handling
handleFailure() {

    # Send an alert email
    message="🔥 🔥 🔥 🔥  Failure Alert: $1 🔥 🔥 🔥 🔥"
    echo $message
    # mail -s "Failure Alert" $recipientEmail < /dev/null
}

# Cleanup
cleanup() {
    rm -rf $cookiesFile
}


# Run all of the tests
statusTest
loginTest
secureTest
ajaxTest
dataTest "50"
dataTest "1"
dataTest "2"
swapNetwork
cleanup

