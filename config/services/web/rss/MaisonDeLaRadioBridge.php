<?php

$GLOBALS['DATE_FORMATTER'] = new IntlDateFormatter(
    "fr-FR",
    IntlDateFormatter::FULL,
    IntlDateFormatter::NONE,
    'Etc/UTC',
    IntlDateFormatter::GREGORIAN,
    'EEEE dd MMMM y'
);

class MaisonDeLaRadioBridge extends XPathAbstract {
    const NAME = 'Maison de la Radio Bridge';
    const URI = 'https://www.maisondelaradioetdelamusique.fr/agenda?type=3188';
    const DESCRIPTION = 'Live Radio France concerts at Maison de la Radio.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 1; // 12h

    const FEED_SOURCE_URL = 'https://www.maisondelaradioetdelamusique.fr/agenda?type=3188';
    const XPATH_EXPRESSION_ITEM = '//a[@class="agenda-event-link"]';
    const XPATH_EXPRESSION_ITEM_TITLE = './/h3';
    const XPATH_EXPRESSION_ITEM_CONTENT = './/div[@class="summary]';
    const XPATH_EXPRESSION_ITEM_URI = './@href';
    const XPATH_EXPRESSION_ITEM_AUTHOR = './/div[@class="type"]';
    const XPATH_EXPRESSION_ITEM_TIMESTAMP = './../div[@class="date"]';
    const XPATH_EXPRESSION_ITEM_ENCLOSURES = './/img/@src';
    const XPATH_EXPRESSION_ITEM_CATEGORIES = './/span[@class="location"]';

    public function getIcon() {
        return 'https://rf-maisondelaradio-production.s3.eu-west-3.amazonaws.com/s3fs-public/mdlrfavicon22.ico';
    }

    protected function formatItemTimestamp($value) {
        return $GLOBALS['DATE_FORMATTER']->parse($value);
    }
}
