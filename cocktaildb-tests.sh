#!/usr/bin/env bash

echo ""

# This uses the test API key 1. Don't abuse this!
COCKTAIL_DB_API=http://www.thecocktaildb.com/api/json/v1/1

if ! type "jq" > /dev/null; then
  echo "You need to install 'jq' to run these tests. You can get it here: http://stedolan.github.io/jq/"
  exit 1
fi

echo "Here is a simple way to format a JSON response:"
curl -s /dev/null ${COCKTAIL_DB_API}/random.php | jq .

echo -n "GET a random recipe"
STATUS=$(curl -so /dev/null -w '%{http_code}' ${COCKTAIL_DB_API}/random.php)
if [ $STATUS -eq 200 ]; then
    echo -n -e "... \033[32mPassed"
else
    echo -n -e "... \033[31mFailed"
fi
echo -e "\033[0m"

echo -n "GET an endpoint that doesn't exist"
STATUS=$(curl -so /dev/null -w '%{http_code}' ${COCKTAIL_DB_API}/woo.php)
if [ $STATUS -eq 404 ]; then
    echo -n -e "... \033[32mPassed"
else
    echo -n -e "... \033[31mFailed"
fi
echo -e "\033[0m"

echo -n "Count the number of Vodka drinks... "
COUNT=$(curl -s ${COCKTAIL_DB_API}/filter.php\?i\=Vodka | jq '.drinks | length')
echo "There are ${COUNT} Vodka drinks."

echo -n "How many drinks don't have thumbnail images? ..."
NULL_THUMBNAIL_COUNT=$(curl -s ${COCKTAIL_DB_API}/filter.php\?i\=Vodka | jq '[.drinks[] | select(.strDrinkThumb == null)] | length')
echo " ${NULL_THUMBNAIL_COUNT}"
