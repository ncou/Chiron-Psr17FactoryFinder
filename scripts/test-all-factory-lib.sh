#!/bin/bash

if [ -z "$COMPOSER_FLAGS" ]; then
    COMPOSER_FLAGS=
fi

echo
echo "<comment>Backing up package state ...</>"
echo
composerBackup=$(cat composer.json)

#composer remove --dev -n nyholm/psr7 php-http/guzzle6-adapter

testImplementation() {
    echo -e "<bg=blue>Testing $1 version $2 ...</>"
    echo
    composer require --dev -n $COMPOSER_FLAGS "$1" "$2"
    composer test-factory || return 1
    composer remove --dev -n "$1"
    echo
    return 0
}

testImplementation nyholm/psr7 "^1.1" || exit 1
#testImplementation guzzlehttp/psr7 "^2.0" || exit 1
testImplementation zendframework/zend-diactoros "^2.1" || exit 1
testImplementation slim/psr7 "^0.3" || exit 1

echo "<comment>Resetting package state ...</comment>"
echo "$composerBackup" > composer.json
composer update -n -q $COMPOSER_FLAGS
