<?php

$GLOBALS['DATE_FORMATTER'] = new IntlDateFormatter(
    'fr-FR',
    IntlDateFormatter::FULL,
    IntlDateFormatter::SHORT,
    'Etc/UTC',
    IntlDateFormatter::GREGORIAN,
    "dd MMMM y EEEE hh'h'mm"
);

class MaisonDeLaRadioBridge extends XPathAbstract {
    const NAME = 'Maison de la Radio Bridge';
    const URI = 'https://www.maisondelaradioetdelamusique.fr/agenda';
    const DESCRIPTION = 'Agenda of the Maison de la Radio et de la Musique.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 3600; // 1h

    const FEED_SOURCE_URL = 'https://www.maisondelaradioetdelamusique.fr/agenda';
    const XPATH_EXPRESSION_ITEM = '//div[@class="hero-header--agenda text-white"]';
    const XPATH_EXPRESSION_ITEM_TITLE = './/div[@class="Bolder-Large-XL mb-5 field_title"]';
    const XPATH_EXPRESSION_ITEM_URI = './/div[@class="d-flex"]//a/@href';
    const XPATH_EXPRESSION_ITEM_AUTHOR = './/div[@class="d-flex flex-column"]/div[2]';
    const XPATH_EXPRESSION_ITEM_TIMESTAMP = './/div[@class="date text-uppercase text-center"]';
    const XPATH_EXPRESSION_ITEM_ENCLOSURES = './/div[@class="bg-wrapper"]/img/@src';
    const XPATH_EXPRESSION_ITEM_CATEGORIES = './/div[@class="SurTitre mb-5 field_event_type"]/text()';

    const PARAMETERS = array(
        '' => array (
            'type' => array(
                'name' => 'Type',
                'type' => 'list',
                'title' => 'Concert types.',
                'values' => array(
                    'Tous' => 0,
                    'Concert' => 2543,
                    'Émission en public' => 1270,
                    'Évènement' => 1273,
                    'Rencontre' => 1272,
                    'Exposition' => 1768,
                    'Festival' => 2544,
                    'Conert jeune public' => 1482
                )
            ),
            'genre' => array(
                'name' => 'Genre',
                'type' => 'list',
                'title' => 'Music genre.',
                'values' => array(
                    'Tous' => 0,
                    'Symphonique' => '1207',
                    'Opéra' => '1212',
                    'Musique baroque' => '1208',
                    'Musique chorale' => '1211',
                    'Musique de film' => '2542',
                    'Récital et musique de chambre' => '1210',
                    'Orgue' => '1214',
                    'Jazz' => '1761',
                    'Création contemporaine' => '1215',
                    'Concert Jeune public' => '2584',
                    'Tournée' => '2583',
                    'Pop, rock et électro' => '2541',
                    'Concert Fip' => '1225',
                    'Atelier musical' => '1258',
                    'Masterclasse' => '1251',
                    'Concerts du soir et avant-concerts pour les scolaires' => '2560',
                    'Concerts jeune public pour le champ social' =>'2581'
                )
            ),
            'formation' => array(
                'name' => 'Formation',
                'type' => 'list',
                'title' => 'Performing formations.',
                'values' => array(
                    'Tous' => 0,
                    'Orchestre Philharmonique de Radio France' => '864%2B2660%2B3333',
                    'Orchestre National de France' => '861%2B1786',
                    'Chœur de Radio France' => '703%2B2946',
                    'Maîtrise de Radio France' => '832%2B2947'
                )
            ),
            'chef' => array(
                'name' => 'Chef',
                'type' => 'number',
                'title' => 'ID of the conductor (optional).',
                'exampleValue' => '53',
            ),
            'compositeur' => array(
                'name' => 'Compositeur',
                'type' => 'number',
                'title' => 'ID of the composer (optional).',
                'exampleValue' => '131',
            ),
            'soliste' => array(
                'name' => 'Soliste',
                'type' => 'number',
                'title' => 'ID of the solist (optional).',
                'exampleValue' => '3064',
            )
        )
    );

    public function getSourceUrl() {
        $query = 'layout=row' . '&a-partir=' . date('Y-m-d');
        foreach(self::PARAMETERS[''] as $param => $paramSpec) {
            $val = $this->getInput($param);
            if($val != 0 && !is_null($val)) {
                if($paramSpec['type'] == 'list') {
                    $assignmentOp = '[]=';
                } else {
                    $assignmentOp = '=';
                }
                $query = $query . '&' . $param . $assignmentOp . $val;
            }
        }
        return self::URI . '?' . $query;
    }

    public function getIcon() {
        return 'https://rf-maisondelaradio-production.s3.eu-west-3.amazonaws.com/s3fs-public/mdlrfavicon22.ico';
    }

    protected function getExpressionItemContent() {
        return 'string(.//div[contains(@class, "Serif-small")])';
    }
    protected function formatItemContent($value) {
        $normalizedWhitespace = preg_replace('/\s\s+/m', ' ', $value);
        return preg_replace('/\s*,/', ',', $normalizedWhitespace);
    }

    protected function getExpressionItemTimestamp() {
        return 'normalize-space(concat(string(' . self::XPATH_EXPRESSION_ITEM_TIMESTAMP . '), .//div[@class="d-flex flex-column"]/div[1]))';
    }
    protected function formatItemTimestamp($value) {
        return $GLOBALS['DATE_FORMATTER']->parse($value);
    }
}
