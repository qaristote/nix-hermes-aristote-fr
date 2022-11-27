<?php

class FipAlbumsBridge extends XPathAbstract {
    const NAME = 'Fip Albums Bridge';
    const URI = 'https://www.radiofrance.fr/fip/albums/';
    const DESCRIPTION = 'Albums promoted by Fip.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 86400; // 6h

    const PARAMETERS = [
        '' => [
            'category' => [
                'name' => 'Category',
                'type' => 'text',
                'description' => 'See examples for available options.',
                'exampleValue' => 'can be empty, "selections" or "album-jazz-de-la-semaine"'
            ]
        ]
    ];

    const XPATH_EXPRESSION_ITEM = '//div[@class="Card Basic list squaredVisual"]';
    const XPATH_EXPRESSION_ITEM_TITLE = './/a/@title';
    const XPATH_EXPRESSION_ITEM_CONTENT = './div[1]';
    const XPATH_EXPRESSION_ITEM_URI = './/a/@href';
    const XPATH_EXPRESSION_ITEM_AUTHOR = './/div[@class="CardDetails fullWidth"]/div[2]';
    const XPATH_EXPRESSION_ITEM_TIMESTAMP = './/time/@datetime';
    const XPATH_EXPRESSION_ITEM_ENCLOSURES = './/img/@src';
    const XPATH_EXPRESSION_ITEM_CATEGORIES = './/div[@class="CardDetails fullWidth"]/div[3]';

    public function getSourceUrl() {
        return self::URI . $this->getInput('category');
    }

    public function getIcon() {
        return 'https://www.radiofrance.fr/dist/favicons/fip/favicon.png';
    }

    protected function formatItemTimestamp($value) {
        return strtotime('today +' . $value);
    }
}
