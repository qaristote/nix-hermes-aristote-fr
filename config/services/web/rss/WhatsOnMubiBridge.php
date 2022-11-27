<?php

class WhatsOnMubiBridge extends XPathAbstract {
    const NAME = 'What\'s on Mubi Bridge';
    const URI = 'https://whatsonmubi.com/?catalogue=ns&sort=expires-desc';
    const DESCRIPTION = 'Movies currently showing on Mubi.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 21800; // 6h

    const PARAMETERS = [
        '' => [
            'country' => [
                'name' => 'Country',
                'type' => 'text',
                'exampleValue' => 'fr',
                'defaultValue' => 'fr',
            ]
        ]
    ];

    const XPATH_EXPRESSION_ITEM = '//div[@class="film"]';
    const XPATH_EXPRESSION_ITEM_TITLE = './/h2';
    const XPATH_EXPRESSION_ITEM_CONTENT = './/div[@class="film_details flex flex-col flex-1"]';
    const XPATH_EXPRESSION_ITEM_URI = './/a[@class="relative film_thumbnail"]/@href';
    const XPATH_EXPRESSION_ITEM_AUTHOR = './@data-directors';
    const XPATH_EXPRESSION_ITEM_TIMESTAMP = './/p[@class="hidden film-expires"]';
    const XPATH_EXPRESSION_ITEM_ENCLOSURES = './/a[@class="relative film_thumbnail"]/img/@src';
    const XPATH_EXPRESSION_ITEM_CATEGORIES = './/div[@class="film_details flex flex-col flex-1"]//div[@class="mt-3 flex flex-wrap"]';

    public function getSourceUrl() {
        return self::URI . '&showing=' . $this->getInput('country');
    }

    public function getIcon() {
        return 'https://whatsonmubi.com/favicon.ico';
    }

    protected function formatItemTimestamp($value) {
        return strtotime('today +' . $value);
    }

    protected function formatItemContent($value) {
        $text = preg_replace("/\s{2}\s+/", "\n", $value);
        $lines = array_map("trim", explode("\n", $text));
        $title = $lines[0];
        $director = $lines[1];
        return $director . ' ' . $title;
    }
}
