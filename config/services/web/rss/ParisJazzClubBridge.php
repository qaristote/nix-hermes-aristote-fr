<?php

class ParisJazzClubBridge extends XPathAbstract {
    const NAME = 'Paris Jazz Club Bridge';
    const URI = 'https://www.parisjazzclub.net/en/agenda-free/';
    const DESCRIPTION = 'Free concerts for the Paris Jazz Club subscribers.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 86400; // 24h

    const FEED_SOURCE_URL = 'https://www.parisjazzclub.net/en/agenda-free/';
    const XPATH_EXPRESSION_ITEM = '//div[@class="col-12 mb-5 concerts-items"]';
    const XPATH_EXPRESSION_ITEM_TITLE = './/h3';
    const XPATH_EXPRESSION_ITEM_CONTENT = '.';
    const XPATH_EXPRESSION_ITEM_URI = './/a/@href';
    const XPATH_EXPRESSION_ITEM_AUTHOR = './/i[@class="fa fa-fw fa-street-view text-ocre"]/..';
    const XPATH_EXPRESSION_ITEM_TIMESTAMP = './/i[@class="fa fa-fw fa-calendar text-ocre"]/..';
    const XPATH_EXPRESSION_ITEM_ENCLOSURES = './/img[@class="img"]/@src';
    const XPATH_EXPRESSION_ITEM_CATEGORIES = './/i[@class="fa fa-fw fa-music text-ocre"]/..';

    public function getIcon() {
        return 'https://www.parisjazzclub.net/favicon/favicon.ico';
    }

    protected function formatItemTimestamp($value) {
        $date = str_replace("/", "-", substr($value, -10));
        return strtotime($date);
    }

    protected function formatItemContent($value) {
        $text = preg_replace("/\s{2}\s+/", "\n", $value);
        $lines = array_map("trim", explode("\n", $text));
        $time = $lines[0];
        $title = $lines[1];
        $club = $lines[2];
        $location = $lines[3];
        $category = $lines[4];
        $date = $lines[5];
        return $title . "," . $category . " -" . $club . "," . $location . " -" . $date . ", " . $time;
    }
}
