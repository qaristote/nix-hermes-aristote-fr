<?php

function tryGetDescription($obj) {
    if (property_exists($obj, 'primary_film_group')
        && !is_null($obj->primary_film_group)) {
        return $obj->primary_film_group->description_html . '<br>';
    } else {
        return '';
    }
}

class MubiBridge extends XPathAbstract {
    const NAME = 'Mubi Bridge';
    const URI = 'https://mubi.com';
    const DESCRIPTION = 'Mubi\'s film of the day.';
    const MAINTAINER = 'Quentin Aristote';
    const CACHE_TIMEOUT = 21600; // 6h

    const PARAMETERS = [
        '' => [
            'language' => [
                'name' => 'Language',
                'type' => 'string',
                'required' => 'true',
                'exampleValue' => 'en / de / es / fr / it / nl / pt / tr'
            ]
        ]
    ];

    public function getIcon() {
        return 'https://mubi.com/favicon.ico';
    }

    public function getUri() {
        return self::URI . '/' . $this->getInput('language') . '/film-of-the-day';
    }

    public function collectData() {
        $dataJsonStr = extractFromDelimiters(
            getSimpleHTMLDOMCached($this->getUri()),
            '<script id="__NEXT_DATA__" type="application/json">',
            '</script>');
        $data = json_decode($dataJsonStr)->props->initialState;
        foreach ($data->filmProgramming->filmProgrammings as $filmProgramming) {
            $id = $filmProgramming->filmId;
            $film = $data->film->films->{$id};
            $item = [
                'title'      => $filmProgramming->email_subject,
                'uri'        => 'https://mubi.com/' . $this->getInput('language') . '/films/' . $film->slug,
                'timestamp'  => strtotime($filmProgramming->available_at), 
                'author'     => $film->directors[0]->name,
                'content'    => (
                    $filmProgramming->our_take_html . '<br>' .
                    tryGetDescription($filmProgramming) .
                    $film->short_synopsis_html . '<br>' .
                    $film->default_editorial_html
                ),
                'enclosures' => [
                    $film->stills->standard,
                    $film->trailer_url
                ],
                'categories' => $film->genres,
                'uid'        => $id . $filmProgramming->available_at
            ];
            $this->items[] = $item;
        }
    }
}
