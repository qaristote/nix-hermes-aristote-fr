<?php

class RandonavigoBridge extends XPathAbstract {
    const NAME = 'Randonavigo Bridge';
    const URI = 'https://www.randonavigo.fr/';
    const DESCRIPTION = 'Hiking trails in Île-de-France.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 86400; // 24h

    const FEED_SOURCE_URL = 'https://www.randonavigo.fr/';
    const XPATH_EXPRESSION_ITEM = '//article';
    const XPATH_EXPRESSION_ITEM_TITLE = './/h2/a/text()';
    const XPATH_EXPRESSION_ITEM_CONTENT = './div/div[1]/div[2]/text()';
    const XPATH_EXPRESSION_ITEM_URI = './a/@href';
    const XPATH_EXPRESSION_ITEM_AUTHOR = './div/div[1]/div[1]/div/text()';
    const XPATH_EXPRESSION_ITEM_TIMESTAMP = './a/@href';
    const XPATH_EXPRESSION_ITEM_ENCLOSURES = './a//img/@src';
    const XPATH_EXPRESSION_ITEM_CATEGORIES = './div/div[2]//a/@title';

    public function getIcon() {
        return 'https://www.randonavigo.fr/apple-touch-icon.png';
    }

    protected function formatItemTimestamp($value) {
        $pattern = "/\/([0-9]+)/";
        preg_match_all($pattern, $value, $matches);
        return strtotime(join('-', $matches[1]));
    }

    protected function cleanMediaUrl($value) {
        return $value;
    }
}
