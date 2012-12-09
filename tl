#!/usr/bin/env ruby
#
# Affiche les prochains bus/metros d'apres les données accessibles sur le site
# des transports publics lausannois (http://www.t-l.ch/).
#
# Copyleft 2012 François Deppierraz
# License GPL
#
# 09.12.2012 - Initial release

##### CONFIG

STOPS = {
  '13-loz' => ['13|Provence Nord - Verdeil|13', 'Montelly', 'A'],
  '13-provence' => ['13|Provence Nord - Verdeil|13', 'Montelly', 'R'],
  'm1-loz' => ['70|Renens-Gare - Lausanne-Flon|70', 'Montelly', 'A'],
  'm1-renens' => ['70|Renens-Gare - Lausanne-Flon|70', 'Montelly', 'R'],
}

##### END CONFIG

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'time'
require 'uri'

def download_horaire(ligne, arret, sens)
  url = "http://www.t-l.ch/index.php?option=com_tl&task=hd&Itemid=7&arret=#{URI.escape(arret)}&ligne=#{URI.escape(ligne)}&sens=#{URI.escape(sens)}"

  path = "html body table#body_table tbody tr td table#tbmain1 tbody tr td#container div#content_box.content_voyages div.content_box_voyages_step2 table tbody tr"

  doc = Hpricot(open(url))

  return (doc/"div.content_box_voyages_step2//tr").collect {|x| (x/"td").inner_html }
end

stop_name_length = STOPS.keys.collect{|x| x.length}.max

STOPS.keys.each do |nom|
  (ligne, arret, sens) = STOPS[nom]
  prochains = download_horaire(ligne, arret, sens)
  prochains.pop # Enleve "* Ces horaires sont théoriques"
  puts nom.ljust(stop_name_length) + " " + prochains.join(" | ")
end
