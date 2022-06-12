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
    const URI = 'https://www.maisondelaradioetdelamusique.fr/agenda';
    const DESCRIPTION = 'Agenda of the Maison de la Radio et de la Musique.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 43200; // 12h

    const XPATH_EXPRESSION_ITEM = '//a[@class="agenda-event-link"]';
    const XPATH_EXPRESSION_ITEM_TITLE = './/h3';
    const XPATH_EXPRESSION_ITEM_CONTENT = './/div[@class="summary]';
    const XPATH_EXPRESSION_ITEM_URI = './@href';
    const XPATH_EXPRESSION_ITEM_AUTHOR = './/div[@class="type"]';
    const XPATH_EXPRESSION_ITEM_TIMESTAMP = './../div[@class="date"]';
    const XPATH_EXPRESSION_ITEM_ENCLOSURES = './/img/@src';
    const XPATH_EXPRESSION_ITEM_CATEGORIES = './/span[@class="location"]';

    const PARAMETERS = array(
        '' => array (
            'type' => array(
                'name' => 'Type',
                'type' => 'number',
                'title' => 'ID of the concert type (optional).',
                'exampleValue' => '3188'
            ),
            'formation' => array(
                'name' => 'Formation',
                'type' => 'number',
                'title' => 'ID of the performing formation (optional).',
                'exampleValue' => '1035'
            ),
            'chef' => array(
                'name' => 'Chef',
                'type' => 'number',
                'title' => 'ID of the conductor (optional).',
                'exampleValue' => '53'
            ),
            'compositeur' => array(
                'name' => 'Compositeur',
                'type' => 'number',
                'title' => 'ID of the composer (optional).',
                'exampleValue' => '131'
            ),
            'soliste' => array(
                'name' => 'Soliste',
                'type' => 'number',
                'title' => 'ID of the solist (optional).',
                'exampleValue' => '3064'
            )
        )
    );

    public function getSourceUrl() {
        $query = '';
        foreach(self::PARAMETERS[''] as $param => $val) {
            $query = $query . $param . '=' . $this->getInput($param) . '&'; 
        }
        return self::URI . '?' . $query;
    }

    public function getIcon() {
        return 'https://rf-maisondelaradio-production.s3.eu-west-3.amazonaws.com/s3fs-public/mdlrfavicon22.ico';
    }

    protected function formatItemTimestamp($value) {
        return $GLOBALS['DATE_FORMATTER']->parse($value);
    }
}
