<?php

class ParisCineInfoBridge extends BridgeAbstract {
    const NAME = 'Paris-ciné.info Bridge';
    const URI = 'https://paris-cine.info/';
    const DESCRIPTION = 'Movies playing in Paris';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 86400; // 24h

    const PARAMETERS = [
        'Filters' => [
            // TODO add an option for choosing the reviewer
            'card' => [
                'name' => 'Card',
                'type' => 'text',
                'title' => 'Fidelity / subscription card.',
                'exampleValue' => 'ugc',
                'defaultValue' => 'all'
            ],
            'dayid' => [
                'name' => 'Day of the week',
                'type' => 'text',
                'title' => 'Comma-separated list of integers (0 means everyday, 1 means Sunday, etc.)/',
                'exampleValue' => '1,3,6',
                'defaultValue' => '0'
            ],
            'time' => [
                'name' => 'Time of day',
                'type' => 'text',
                'title' => 'Morning (8AM-12AM), Afternoon (12AM-18PM), Evening (18PM-12PM).',
                'exampleValue' => 'soir',
                'defaultValue' => 'all'
            ],
            'addr' => [
                'name' => 'Location',
                'type' => 'text',
                'title' => 'Comma-separated list of districts or cities.',
                'exampleValue' => '13e,Châtillon',
                'defaultValue' => 'Paris'
            ],
            'cine' => [
                'name' => 'Theater',
                'type' => 'text',
                'title' => 'ID of a movie theater.',
                'exampleValue' => 'C0150',
            ],
            'format' => [
                'name' => 'Format',
                'type' => 'text',
                'title' => 'Movie format.',
                'exampleValue' => '3D'
            ]
        ]
    ];

    public function getSourceUrl() {
        $query = '';
        foreach(self::PARAMETERS['Filters'] as $param => $val) {
            $value = $this->getInput($param);
            if ($value != '') {
                $query = $query . 'sel' . $param . '=' . $value . '&';
            }
        }
        $selday = ['week', 'dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'][$this->getInput('dayid')];
        return self::URI . 'get_pcimovies.php?' . $query . 'selday=' . $selday;
    }

    private function fetchData() {
        return json_decode(getSimpleHTMLDOMCached($this->getSourceUrl()))->data;
    }

    public function getIcon() {
        return 'https://paris-cine.info/resources/img/favicon-16x16.png';
    }

    public function collectData() {
        $data = $this->fetchData();
        foreach($data as $film) {
            $item = [
                'uri' => str_replace('\\/', '/', $film->sc_url),
                'title' => $film->title,
                'timestamp' => str_replace('/', '-', $film->released),
                'author' => $film->dir,
                'content' => (
                    $film->year . ' - ' .
                    'with ' . str_replace(',', ', ', $film->actors) . ' - ' .
                    $film->duration . ' - ' .
                    'SC:   ' . $film->sc_rating . '/10 - ' .
                    'IMDB: ' . $film->imdbr  . '/10' . ' '
                ),
                'enclosures' => [ $film->poster_url ],
                'categories' => explode(',', $film->genre),
                'id' => $film->id
            ];
            $this->items[] = $item;
        } 
    }
}
