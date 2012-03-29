# -*- encoding : utf-8 -*-
require 'spec_helper'

require 'spreadsheet'

class MockInternalController
  include HRWA::Internal
end

describe 'HRWA::Internal' do     
  it '#seed_list_excel_workbook' do
    expected_rows = spreadsheet_to_rows( expected_seed_list_workbook.worksheet 'Seed List' )
    got_rows      = spreadsheet_to_rows(
      MockInternalController.new.seed_list_excel_workbook.worksheet 'Seed List'
    )
    got_rows.should == expected_rows
  end
end

def spreadsheet_to_rows( spreadsheet )
  rows = []
  spreadsheet.each_with_index { | sheet_row, index |
    rows[ index ] = sheet_row.inject( :+ )
  }
  return rows
end

def expected_seed_list_workbook
  response = expected_seed_list_solr_response 
  
  Spreadsheet.client_encoding = 'UTF-8' 
  workbook = Spreadsheet::Workbook.new
  sheet    = workbook.create_worksheet :name => 'Seed List'
  
  rows_to_write_to_sheet = { }
  response[ 'response' ][ 'docs' ].each_with_index { | doc, index | 
    seed_urls = doc[ 'original_urls' ]
    seed_urls.each { | seed_url |
      rows_to_write_to_sheet[ seed_url ] = { } 
      rows_to_write_to_sheet[ seed_url ][ 'id'    ] = doc[ 'id'    ]
      rows_to_write_to_sheet[ seed_url ][ 'title' ] = doc[ 'title' ]
    }
  }
  
  rows_to_write_to_sheet.keys.sort.each_with_index { | seed_url, index |
    sheet[ index, 0 ] = seed_url
    sheet[ index, 1 ] = rows_to_write_to_sheet[ seed_url ][ 'id'    ]
    sheet[ index, 2 ] = rows_to_write_to_sheet[ seed_url ][ 'title' ]
  }
  
  return workbook
end

def expected_seed_list_solr_response
  # http://carter.cul.columbia.edu:8080/solr-4/hrwa_blacklight-fsf-unit-test/select/?q=*%3A*&version=2.2&start=0&indent=on&sort=title__facet+asc&wt=ruby&rows=99999&fl=title,id
  return \
{
  'responseHeader'=>{
    'status'=>0,
    'QTime'=>2,
    'params'=>{
      'sort'=>'title__facet asc',
      'version'=>'2.2',
      'fl'=>'original_urls,title,id',
      'indent'=>'on',
      'wt'=>'ruby',
      'rows'=>'99999',
      'start'=>'0',
      'q'=>'*:*'}},
  'response'=>{'numFound'=>441,'start'=>0,'docs'=>[
      {
        'id'=>'9006313',
        'title'=>'"İnsan Hüquqları XXI ăsr-Azărbaycan" Fondu',
        'original_urls'=>['http://www.azhumanrights.az/']},
      {
        'id'=>'7832247',
        'title'=>'5·18 Kinyŏm Chaedan : The May 18 Memorial Foundation.',
        'original_urls'=>['http://www.518.org/']},
      {
        'id'=>'7038343',
        'title'=>'AFAPREDESA',
        'original_urls'=>['http://www.afapredesa.org/index.php']},
      {
        'id'=>'9085460',
        'title'=>'ANDHES',
        'original_urls'=>['http://www.andhes.org.ar/']},
      {
        'id'=>'7885543',
        'title'=>'ASPER : Associazione per la tutela dei diritti umani del popolo eritreo  = Association for the Defense of Human Rights of the Eritrean People.',
        'original_urls'=>['http://www.asper-eritrea.com/']},
      {
        'id'=>'7038450',
        'title'=>'AWARE',
        'original_urls'=>['http://www.aware.org.sg/']},
      {
        'id'=>'7038393',
        'title'=>'Abuelas de Plaza de Mayo',
        'original_urls'=>['http://www.abuelas.org.ar/']},
      {
        'id'=>'7876840',
        'title'=>'Access to Justice',
        'original_urls'=>['http://www.accesstojustice-ng.org/']},
      {
        'id'=>'8775896',
        'title'=>'Ação Brasileira pela Nutrição e Direitos Humanos',
        'original_urls'=>['http://www.abrandh.org.br/']},
      {
        'id'=>'7038763',
        'title'=>'Adalah',
        'original_urls'=>['http://www.adalah.org/eng/index.php']},
      {
        'id'=>'8481136',
        'title'=>'Advocacy Forum--Nepal',
        'original_urls'=>['http://advocacyforum.org/']},
      {
        'id'=>'7038582',
        'title'=>'Afghanistan Independent Human Rights Commission',
        'original_urls'=>['http://www.aihrc.org.af/']},
      {
        'id'=>'7038697',
        'title'=>'Africa Internally Displaced Persons Voice',
        'original_urls'=>['http://www.africaidp.org/']},
      {
        'id'=>'7038465',
        'title'=>'African Centre for Democracy and Human Rights Studies',
        'original_urls'=>['http://www.acdhrs.org/']},
      {
        'id'=>'8971728',
        'title'=>'African Commission on Human and Peoples\' Rights : Commission africaine des droits de l\'homme et des peuples',
        'original_urls'=>['http://www.achpr.org/']},
      {
        'id'=>'7038762',
        'title'=>'Al-Dameer Association for Human Rights',
        'original_urls'=>['http://www.aldameer.org/ar/index.php']},
      {
        'id'=>'7038761',
        'title'=>'Al-Haq',
        'original_urls'=>['http://www.alhaq.org/']},
      {
        'id'=>'8415458',
        'title'=>'Al-Jamʻīyah al-Waṭanīyah lil-Taghyīr',
        'original_urls'=>['http://www.taghyeer.net/']},
      {
        'id'=>'7038661',
        'title'=>'Albanian Center for Human Rights',
        'original_urls'=>['http://www.achr.org/en/index.html']},
      {
        'id'=>'7038662',
        'title'=>'Algeria-Watch',
        'original_urls'=>['http://www.algeria-watch.org/index_en.htm']},
      {
        'id'=>'8961300',
        'title'=>'Alianța Civică a Romilor din Romania',
        'original_urls'=>['http://www.acrr.ro/']},
      {
        'id'=>'7038567',
        'title'=>'Amigos de las Mujeres de Juarez',
        'original_urls'=>['http://amigosdemujeres.org/']},
      {
        'id'=>'7902541',
        'title'=>'Amman Center for Human Rights Studies : Markaz ʻAmmān li-Dirāsāt Ḥuqūq al-Insān.',
        'original_urls'=>['http://www.achrs.org/']},
      {
        'id'=>'5421151',
        'title'=>'Amnesty International',
        'original_urls'=>['http://www.amnesty.org']},
      {
        'id'=>'8539187',
        'title'=>'Amnesty International : le site d\'Amnesty Belgique Francophone.',
        'original_urls'=>['http://www.amnesty.be']},
      {
        'id'=>'8557219',
        'title'=>'Amnesty International Aotearoa New Zealand',
        'original_urls'=>['http://www.amnesty.org.nz/']},
      {
        'id'=>'8539206',
        'title'=>'Amnesty International Canada',
        'original_urls'=>['http://amnesty.ca/']},
      {
        'id'=>'8540001',
        'title'=>'Amnesty International ČR',
        'original_urls'=>['http://www.amnesty.cz/']},
      {
        'id'=>'8539223',
        'title'=>'Amnesty International Deutschland',
        'original_urls'=>['http://amnesty.de/']},
      {
        'id'=>'8857446',
        'title'=>'Amnesty International European Institutions Office',
        'original_urls'=>['http://www.amnesty.eu/']},
      {
        'id'=>'8539218',
        'title'=>'Amnesty International France',
        'original_urls'=>['http://www.amnesty.fr/']},
      {
        'id'=>'8539234',
        'title'=>'Amnesty International Ghana',
        'original_urls'=>['http://amnestyghana.org/']},
      {
        'id'=>'8618609',
        'title'=>'Amnesty International Hong Kong',
        'original_urls'=>['http://www.amnesty.org.hk/']},
      {
        'id'=>'8616335',
        'title'=>'Amnesty International Hrvatske',
        'original_urls'=>['http://www.amnesty.hr']},
      {
        'id'=>'8602577',
        'title'=>'Amnesty International Luxembourg',
        'original_urls'=>['http://www.amnesty.lu/']},
      {
        'id'=>'8502198',
        'title'=>'Amnesty International Magyarország',
        'original_urls'=>['http://amnesty.hu/']},
      {
        'id'=>'8540401',
        'title'=>'Amnesty International Mauritius Section',
        'original_urls'=>['http://amnestymauritius.org/']},
      {
        'id'=>'8455301',
        'title'=>'Amnesty International Moldova',
        'original_urls'=>['http://www.amnesty.md/']},
      {
        'id'=>'8540054',
        'title'=>'Amnesty International Nepal',
        'original_urls'=>['http://amnestynepal.org/']},
      {
        'id'=>'8616886',
        'title'=>'Amnesty International Nihon Shibu',
        'original_urls'=>['http://amnesty.or.jp/']},
      {
        'id'=>'8519721',
        'title'=>'Amnesty International Österreich',
        'original_urls'=>['http://www.amnesty.at/']},
      {
        'id'=>'8540838',
        'title'=>'Amnesty International Philippines',
        'original_urls'=>['http://www.amnesty.org.ph/']},
      {
        'id'=>'8513355',
        'title'=>'Amnesty International Polska',
        'original_urls'=>['http://amnesty.org.pl/']},
      {
        'id'=>'8557218',
        'title'=>'Amnesty International Schweiz',
        'original_urls'=>['http://www.amnesty.ch/de']},
      {
        'id'=>'8585979',
        'title'=>'Amnesty International Sénégal',
        'original_urls'=>['http://amnesty.sn/']},
      {
        'id'=>'8540825',
        'title'=>'Amnesty International Slovensko',
        'original_urls'=>['http://www.amnesty.sk/']},
      {
        'id'=>'8602843',
        'title'=>'Amnesty International South Africa',
        'original_urls'=>['http://www.amnesty.org.za/']},
      {
        'id'=>'8586037',
        'title'=>'Amnesty International Taiwan = : Guo ji te she zu zhi Taiwan zong hui',
        'original_urls'=>['http://amnesty.tw/']},
      {
        'id'=>'9065537',
        'title'=>'Amnesty International [Australia]',
        'original_urls'=>['http://www.amnesty.org.au/']},
      {
        'id'=>'8519817',
        'title'=>'Amnesty International [Danmark]',
        'original_urls'=>['http://www.amnesty.dk/']},
      {
        'id'=>'8539378',
        'title'=>'Amnesty International [Finland]',
        'original_urls'=>['http://www.amnesty.fi']},
      {
        'id'=>'8585473',
        'title'=>'Amnesty International [Ireland]',
        'original_urls'=>['http://amnesty.ie/']},
      {
        'id'=>'9055223',
        'title'=>'Amnesty International [Italy]',
        'original_urls'=>['http://www.amnesty.it']},
      {
        'id'=>'9065459',
        'title'=>'Amnesty International [Netherlands]',
        'original_urls'=>['http://www.amnesty.nl/']},
      {
        'id'=>'8456088',
        'title'=>'Amnesty International [Norge]',
        'original_urls'=>['http://www.amnesty.no/']},
      {
        'id'=>'8519768',
        'title'=>'Amnesty International [Svenska sektionen]',
        'original_urls'=>['http://www.amnesty.se/']},
      {
        'id'=>'8644505',
        'title'=>'Amnesty International [Ukraine]',
        'original_urls'=>['http://amnesty.org.ua/']},
      {
        'id'=>'9055171',
        'title'=>'Amnesty International [United Kingdom]',
        'original_urls'=>['http://www.amnesty.org.uk/']},
      {
        'id'=>'8540895',
        'title'=>'Amnesty International, F�roya deild',
        'original_urls'=>['http://www.amnesty.fo/']},
      {
        'id'=>'8586003',
        'title'=>'Amnesty International, section Togo',
        'original_urls'=>['http://amnesty.tg/']},
      {
        'id'=>'8703322',
        'title'=>'Amnistia Internacional Portugal',
        'original_urls'=>['http://www.amnistia-internacional.pt/']},
      {
        'id'=>'8539259',
        'title'=>'Amnistía Internacional Bolivia',
        'original_urls'=>['http://www.bo.amnesty.org/']},
      {
        'id'=>'8446849',
        'title'=>'Amnistía Internacional Chile',
        'original_urls'=>['http://www.amnistia.cl/web/']},
      {
        'id'=>'8536054',
        'title'=>'Amnistía Internacional México',
        'original_urls'=>['http://amnistia.org.mx/']},
      {
        'id'=>'8446829',
        'title'=>'Amnistía Internacional Puerto Rico',
        'original_urls'=>['http://www.amnistiapr.org/']},
      {
        'id'=>'8446886',
        'title'=>'Amnistía Internacional Uruguay',
        'original_urls'=>['http://www.amnistia.org.uy/']},
      {
        'id'=>'8539239',
        'title'=>'Amnistía Internacional, Sección Argentina',
        'original_urls'=>['http://www.amnesty.org.ar/']},
      {
        'id'=>'8513367',
        'title'=>'Amnistía Internacional, Sección Española',
        'original_urls'=>['http://www.es.amnesty.org/']},
      {
        'id'=>'8513460',
        'title'=>'Amnistía Internacional, Sección Paraguaya',
        'original_urls'=>['http://www.amnesty.org.py/']},
      {
        'id'=>'8602383',
        'title'=>'Andalus Institute for Tolerance and Anti-Violence Studies',
        'original_urls'=>['http://www.andalusitas.net/']},
      {
        'id'=>'8067914',
        'title'=>'Anti Caste Discrimination Alliance',
        'original_urls'=>['http://acda.co/','http://www.acdauk.org.uk/']},
      {
        'id'=>'7038757',
        'title'=>'Arab Association for Human Rights',
        'original_urls'=>['http://www.arabhra.org/']},
      {
        'id'=>'8408203',
        'title'=>'Arab Program for Human Rights Activists',
        'original_urls'=>['http://www.aphra.org/']},
      {
        'id'=>'7038783',
        'title'=>'Arabic Network for Human Rights Information',
        'original_urls'=>['http://www.anhri.net/']},
      {
        'id'=>'7038525',
        'title'=>'Argentine Forensic Anthropology Team : Equipo Argentino de Antropologia Forense.',
        'original_urls'=>['http://eaaf.typepad.com/','http://www.naya.org.ar/eaaf/']},
      {
        'id'=>'6876285',
        'title'=>'Article 19',
        'original_urls'=>['http://www.article19.org/']},
      {
        'id'=>'7038675',
        'title'=>'Asia Pacific Forum : advancing human rights in our region.',
        'original_urls'=>['http://www.asiapacificforum.net/']},
      {
        'id'=>'7038673',
        'title'=>'Asian Centre for Human Rights : dedicated to promotion and protection of human rights in Asia.',
        'original_urls'=>['http://www.achrweb.org/index.htm']},
      {
        'id'=>'7886427',
        'title'=>'Asian Federation Against Involuntary Disappearances',
        'original_urls'=>['http://www.afad-online.org/']},
      {
        'id'=>'7038672',
        'title'=>'Asian Forum for Human Rights and Development',
        'original_urls'=>['http://www.forum-asia.org/']},
      {
        'id'=>'7038674',
        'title'=>'Asian Human Rights Commission',
        'original_urls'=>['http://www.humanrights.asia/']},
      {
        'id'=>'7038747',
        'title'=>'Asian Legal Resource Centre',
        'original_urls'=>['http://www.alrc.net/index.php']},
      {
        'id'=>'7038448',
        'title'=>'Asociación Pro Derechos Humanos',
        'original_urls'=>['http://www.aprodeh.org.pe/']},
      {
        'id'=>'8287713',
        'title'=>'Asociación por los Derechos Civiles',
        'original_urls'=>['http://www.adc.org.ar/']},
      {
        'id'=>'7038518',
        'title'=>'Assistance Association for Political Prisoners (Burma)',
        'original_urls'=>['http://www.aappb.org/']},
      {
        'id'=>'8971608',
        'title'=>'Associação Justiça, Paz e Democracia : Justice, Peace and Democracy Association.',
        'original_urls'=>['http://www.ajpdangola.org/']},
      {
        'id'=>'8413637',
        'title'=>'Association for Freedom of Thought and Expression',
        'original_urls'=>['http://www.en.afteegypt.org']},
      {
        'id'=>'7038748',
        'title'=>'Association for Women\'s Rights in Development',
        'original_urls'=>['http://awid.org/']},
      {
        'id'=>'7038617',
        'title'=>'Association for the Prevention of Torture',
        'original_urls'=>['http://www.apt.ch/']},
      {
        'id'=>'7410021',
        'title'=>'Association marocaine des droits humains',
        'original_urls'=>['http://www.amdh.org.ma/']},
      {
        'id'=>'7902567',
        'title'=>'Association pour le respect des droits de l\'homme à Djibouti : ARDHD.',
        'original_urls'=>['http://www.ardhd.org/']},
      {
        'id'=>'7038329',
        'title'=>'Association sahraouie des victimes des violations graves des droits de l\'homme commises par l\'Etat du Maroc',
        'original_urls'=>['http://asvdh.net/']},
      {
        'id'=>'7038786',
        'title'=>'Australian Human Rights Commission',
        'original_urls'=>['http://www.humanrights.gov.au/']},
      {
        'id'=>'7038742',
        'title'=>'B\'Tselem : The Israeli information center for human rights in the occupied territories.',
        'original_urls'=>['http://www.btselem.org/English/index.asp']},
      {
        'id'=>'7038502',
        'title'=>'BAOBAB for Women\'s Human Rights',
        'original_urls'=>['http://www.baobabwomen.org/']},
      {
        'id'=>'8438804',
        'title'=>'Baheyya : Egypt analysis and whimsy : commentary on Egyptian politics and culture by an Egyptian citizen with a room of her own.',
        'original_urls'=>['http://www.baheyya.blogspot.com/']},
      {
        'id'=>'9170564',
        'title'=>'Basel Action Network : BAN.',
        'original_urls'=>['http://www.ban.org/']},
      {
        'id'=>'7038660',
        'title'=>'Beogradski centar za ljudska prava',
        'original_urls'=>['http://www.bgcentar.org.rs/','http://bgcentar.placebo.co.yu/home_sr']},
      {
        'id'=>'7038378',
        'title'=>'Bermuda Ombudsman',
        'original_urls'=>['http://www.ombudsman.bm']},
      {
        'id'=>'7038755',
        'title'=>'Bimkom',
        'original_urls'=>['http://www.bimkom.org/']},
      {
        'id'=>'9250557',
        'title'=>'British Irish Rights Watch',
        'original_urls'=>['http://www.birw.org/']},
      {
        'id'=>'7813033',
        'title'=>'Burma Lawyers\' Council',
        'original_urls'=>['http://www.blc-burma.org/']},
      {
        'id'=>'7038493',
        'title'=>'CALDH',
        'original_urls'=>['http://www.caldh.org/']},
      {
        'id'=>'7813805',
        'title'=>'CELS, Centro de Estudios Legales y Sociales',
        'original_urls'=>['http://www.cels.org.ar']},
      {
        'id'=>'8618396',
        'title'=>'CONECTAS Direitos Humanos',
        'original_urls'=>['http://www.conectas.org/']},
      {
        'id'=>'8460274',
        'title'=>'CRLDHT--Comité pour le respect des libertés et des droits de l\'homme en Tunisie',
        'original_urls'=>['http://www.crldht.info','http://www.crldht.org']},
      {
        'id'=>'7923757',
        'title'=>'CSVR : Centre for the Study of Violence and Reconciliation.',
        'original_urls'=>['http://www.csvr.org.za/']},
      {
        'id'=>'8857455',
        'title'=>'Cageprisoners',
        'original_urls'=>['http://www.cageprisoners.com/']},
      {
        'id'=>'7410095',
        'title'=>'Cairo Institute for Human Rights Studies',
        'original_urls'=>['http://www.cihrs.org/english/default.aspx']},
      {
        'id'=>'7038586',
        'title'=>'Cambodian League for the Promotion and Defense of Human Rights',
        'original_urls'=>['http://www.licadho-cambodia.org/','http://www.licadho.org/']},
      {
        'id'=>'7038501',
        'title'=>'Campaign for Good Governance',
        'original_urls'=>['http://www.slcgg.org/']},
      {
        'id'=>'7038387',
        'title'=>'Canadian Friends of Burma',
        'original_urls'=>['http://www.cfob.org/']},
      {
        'id'=>'7799921',
        'title'=>'Center for Economic and Social Rights',
        'original_urls'=>['http://www.cesr.org/']},
      {
        'id'=>'7038565',
        'title'=>'Center for Justice and International Law',
        'original_urls'=>['http://www.cejil.org/']},
      {
        'id'=>'7819636',
        'title'=>'Center for Social Development : Majhamandal saṃrap Qbhivadhṅ Sangaṃ',
        'original_urls'=>['http://www.csdcambodia.org/']},
      {
        'id'=>'7038694',
        'title'=>'Centre for Democratic Development, Research and Training',
        'original_urls'=>['http://www.ceddert.com/']},
      {
        'id'=>'7038264',
        'title'=>'Centre for Human Rights and Rehabilitation',
        'original_urls'=>['http://chrr.ultinets.net/']},
      {
        'id'=>'7038639',
        'title'=>'Centre for Victims of Torture, Nepal',
        'original_urls'=>['http://www.cvict.org.np/']},
      {
        'id'=>'7905284',
        'title'=>'Centre for War Victims and Human Rights',
        'original_urls'=>['http://www.cwvhr.org/']},
      {
        'id'=>'9065250',
        'title'=>'Centre for the Development of People',
        'original_urls'=>['http://www.cedepmalawi.org/']},
      {
        'id'=>'9050722',
        'title'=>'Centro Nicaragüense de Derechos Humanos',
        'original_urls'=>['http://www.cenidh.org/']},
      {
        'id'=>'7038492',
        'title'=>'Centro de Derechos Humanos Miguel Agustín Pro Juárez',
        'original_urls'=>['http://centroprodh.org.mx/']},
      {
        'id'=>'7038269',
        'title'=>'Centro de Estudios Sociales Padre Juan Montalvo, S.J.',
        'original_urls'=>['http://www.centrojuanmontalvo.org.do/']},
      {
        'id'=>'7819664',
        'title'=>'Centro de Justicia para la Paz y el Desarrollo',
        'original_urls'=>['http://www.cepad.org.mx']},
      {
        'id'=>'7834591',
        'title'=>'Child Rights Information & Documentation Centre',
        'original_urls'=>['http://www.cridoc.net/']},
      {
        'id'=>'7905016',
        'title'=>'Citizenship Rights in Africa Initiative',
        'original_urls'=>['http://www.citizenshiprightsinafrica.org/']},
      {
        'id'=>'7876812',
        'title'=>'Coalition for an Effective African Court on Human and Peoples\' Rights',
        'original_urls'=>['http://www.africancourtcoalition.org/']},
      {
        'id'=>'7038732',
        'title'=>'Coalition to Stop the Use of Child Soldiers',
        'original_urls'=>['http://www.child-soldiers.org/']},
      {
        'id'=>'7038654',
        'title'=>'Colectivo de Abogados José Alvear Restrepo',
        'original_urls'=>['http://www.colectivodeabogados.org/']},
      {
        'id'=>'7038318',
        'title'=>'Collectif des associations contre l\'impunité au Togo',
        'original_urls'=>['http://www.cacit.org/']},
      {
        'id'=>'7038406',
        'title'=>'Comisionado Nacional de los Derechos Humanos',
        'original_urls'=>['http://www.conadeh.hn/']},
      {
        'id'=>'7038464',
        'title'=>'Comisión Andina de Juristas',
        'original_urls'=>['http://www.cajpe.org.pe/index.html']},
      {
        'id'=>'7038656',
        'title'=>'Comisión Mexicana de Defensa y Promoción de los Derechos Humanos',
        'original_urls'=>['http://www.cmdpdh.org/']},
      {
        'id'=>'7038523',
        'title'=>'Comisión Nacional de los Derechos Humanos, México',
        'original_urls'=>['http://www.cndh.org.mx/']},
      {
        'id'=>'9079545',
        'title'=>'Comisión de la Verdad y Reconciliación',
        'original_urls'=>['http://www.cverdad.org.pe/']},
      {
        'id'=>'7813806',
        'title'=>'Comissão de Acolhimento, Verdade, e Reconciliac̦ão de Timor-Leste',
        'original_urls'=>['http://www.cavr-timorleste.org/']},
      {
        'id'=>'7038369',
        'title'=>'Comité Cubano Pro Derechos Humanos',
        'original_urls'=>['http://www.sigloxxi.org/']},
      {
        'id'=>'7887220',
        'title'=>'Comité de Familiares de Detenidos-Desaparecidos en Honduras',
        'original_urls'=>['http://www.cofadeh.org/']},
      {
        'id'=>'7815173',
        'title'=>'Comité para la Defensa de los Derechos Humanos en Honduras',
        'original_urls'=>['http://codeh.hn/v1/']},
      {
        'id'=>'7038382',
        'title'=>'Comité sénégalaise des droits de l\'homme',
        'original_urls'=>['http://www.csdh.sn/']},
      {
        'id'=>'7757146',
        'title'=>'Commissie Gelijke Behandeling',
        'original_urls'=>['http://www.cgb.nl/']},
      {
        'id'=>'7038413',
        'title'=>'Commission Nationale des Droits de l\'Homme du Togo',
        'original_urls'=>['http://www.cndh-togo.org/']},
      {
        'id'=>'7038407',
        'title'=>'Commission for Human Rights and Good Governance',
        'original_urls'=>['http://www.chragg.go.tz/']},
      {
        'id'=>'7038262',
        'title'=>'Commission nationale consultative des droits de l\'homme',
        'original_urls'=>['http://www.cncdh.fr/']},
      {
        'id'=>'7732061',
        'title'=>'Commission on Human Rights of the Philippines',
        'original_urls'=>['http://www.chr.gov.ph/']},
      {
        'id'=>'7038705',
        'title'=>'Committee to Protect Journalists',
        'original_urls'=>['http://www.cpj.org/']},
      {
        'id'=>'7885012',
        'title'=>'Community Appraisal & Motivation Program',
        'original_urls'=>['http://camp.org.pk/']},
      {
        'id'=>'9076806',
        'title'=>'Congolese Women\'s Campaign Against Sexual Violence in the Democratic Republic of the Congo (DRC)',
        'original_urls'=>['http://www.rdc-viol.org/']},
      {
        'id'=>'7038490',
        'title'=>'Conselho Indigenista Missionário',
        'original_urls'=>['http://www.cimi.org.br/']},
      {
        'id'=>'9217998',
        'title'=>'Control arms',
        'original_urls'=>['http://www.controlarms.org']},
      {
        'id'=>'7038652',
        'title'=>'Coordinadora Nacional de Derechos Humanos',
        'original_urls'=>['http://derechoshumanos.pe/','http://www.dhperu.org/']},
      {
        'id'=>'7038315',
        'title'=>'Coordinadora de Derechos Humanos del Paraguay',
        'original_urls'=>['http://www.codehupy.org/']},
      {
        'id'=>'7038491',
        'title'=>'Corporación de Promoción y Defensa de los Derechos del Pueblo',
        'original_urls'=>['http://www.codepu.cl/index.php']},
      {
        'id'=>'7038447',
        'title'=>'Danish Institute of Human Rights',
        'original_urls'=>['http://humanrights.dk/']},
      {
        'id'=>'7038267',
        'title'=>'Darfur Consortium',
        'original_urls'=>['http://www.darfurconsortium.org/']},
      {
        'id'=>'7038379',
        'title'=>'Defensor del Pueblo de la Nación',
        'original_urls'=>['http://www.dpn.gob.ar/']},
      {
        'id'=>'7038377',
        'title'=>'Defensor del Pueblo, República de Bolivia',
        'original_urls'=>['http://www.defensoria.gob.bo/','http://www.defensor.gov.bo/']},
      {
        'id'=>'7888758',
        'title'=>'Defensores en linea.com',
        'original_urls'=>['http://www.defensoresenlinea.com/cms/']},
      {
        'id'=>'7038374',
        'title'=>'Defensoría del Pueblo [Peru]',
        'original_urls'=>['http://www.defensoria.gob.pe/']},
      {
        'id'=>'7038403',
        'title'=>'Defensoría del Pueblo de Ecuador',
        'original_urls'=>['http://www.dpe.gob.ec/','http://www.defensordelpueblo.gov.ec/']},
      {
        'id'=>'7038375',
        'title'=>'Defensoría del Pueblo de la República de Panamá',
        'original_urls'=>['http://www.defensoriadelpueblo.gob.pa/']},
      {
        'id'=>'7731836',
        'title'=>'Defensoría del Pueblo, República del Paraguay',
        'original_urls'=>['http://www.defensoriadelpueblo.gov.py/']},
      {
        'id'=>'7038546',
        'title'=>'Democracywatch',
        'original_urls'=>['http://www.dwatch-bd.org/index.html']},
      {
        'id'=>'7038521',
        'title'=>'Derechos Chile',
        'original_urls'=>['http://www.chipsites.com/derechos/index_eng.html']},
      {
        'id'=>'7038693',
        'title'=>'Deutsches Institut für Menschenrechte',
        'original_urls'=>['http://www.institut-fuer-menschenrechte.de/']},
      {
        'id'=>'8539924',
        'title'=>'Diethnēs Amnēstia - Hellēniko Tmēma',
        'original_urls'=>['http://www.amnesty.org.gr/']},
      {
        'id'=>'7757269',
        'title'=>'Diskrimineringsombudsmannen',
        'original_urls'=>['http://www.do.se/']},
      {
        'id'=>'7038500',
        'title'=>'Ditshwanelo',
        'original_urls'=>['http://www.ditshwanelo.org.bw/']},
      {
        'id'=>'7038594',
        'title'=>'Down to Earth',
        'original_urls'=>['http://www.downtoearth-indonesia.org/','http://dte.gn.apc.org/']},
      {
        'id'=>'7038532',
        'title'=>'ECPAT International',
        'original_urls'=>['http://www.ecpat.net/']},
      {
        'id'=>'8535465',
        'title'=>'Egyptian Blog for Human Rights',
        'original_urls'=>['http://ebfhr.blogspot.com/']},
      {
        'id'=>'7038790',
        'title'=>'Egyptian Organization for Human Rights',
        'original_urls'=>['http://www.eohr.org/']},
      {
        'id'=>'7038248',
        'title'=>'Electoral Institute of Southern Africa',
        'original_urls'=>['http://www.eisa.org.za/']},
      {
        'id'=>'7038545',
        'title'=>'Empowerment and Rights Institute : Ren zhi quan gong zuo shi.',
        'original_urls'=>['http://www.erichina.org/english/englishhome.htm']},
      {
        'id'=>'7038811',
        'title'=>'Equality and Human Rights Commission',
        'original_urls'=>['http://www.equalityhumanrights.com/']},
      {
        'id'=>'7905779',
        'title'=>'Eritrean Human Rights Electronic Archive',
        'original_urls'=>['http://www.ehrea.org/']},
      {
        'id'=>'7038324',
        'title'=>'Ethiopian Human Rights Council',
        'original_urls'=>['http://www.ehrco.org/']},
      {
        'id'=>'7038443',
        'title'=>'European Roma Rights Center',
        'original_urls'=>['http://www.errc.org/']},
      {
        'id'=>'7815770',
        'title'=>'FOCUS on the Global South',
        'original_urls'=>['http://www.focusweb.org']},
      {
        'id'=>'8455464',
        'title'=>'FOHRID--Human Rights and Democratic Forum',
        'original_urls'=>['http://www.fohrid.org.np/']},
      {
        'id'=>'7038613',
        'title'=>'Famafrique',
        'original_urls'=>['http://www.famafrique.org/']},
      {
        'id'=>'8959846',
        'title'=>'Fond za humanitarno pravo',
        'original_urls'=>['http://www.hlc-rdc.org/']},
      {
        'id'=>'7038606',
        'title'=>'Fond zashchity glasnosti',
        'original_urls'=>['http://www.gdf.ru/']},
      {
        'id'=>'7033265',
        'title'=>'Forces de libération africaines de Mauritanie',
        'original_urls'=>['http://www.flamnet.info/','http://www.flamnet.net/']},
      {
        'id'=>'7038249',
        'title'=>'Forum for African Women Educationalists',
        'original_urls'=>['http://www.fawe.org/']},
      {
        'id'=>'7038691',
        'title'=>'Foundation for Human Rights Initiative',
        'original_urls'=>['http://www.fhri.or.ug/']},
      {
        'id'=>'7038388',
        'title'=>'Friends of Tibet',
        'original_urls'=>['http://www.friendsoftibet.org/']},
      {
        'id'=>'7038808',
        'title'=>'Front Line',
        'original_urls'=>['http://www.frontlinedefenders.org/']},
      {
        'id'=>'7038313',
        'title'=>'Fundación Centro de Derechos Humanos y Ambiente',
        'original_urls'=>['http://www.cedha.org.ar/']},
      {
        'id'=>'7038488',
        'title'=>'Fundación Regional de Asesoría en Derechos Humanos',
        'original_urls'=>['http://www.inredh.org/']},
      {
        'id'=>'7038270',
        'title'=>'Fundación Vicaría de la Solidaridad',
        'original_urls'=>['http://www.vicariadelasolidaridad.cl/']},
      {
        'id'=>'7820127',
        'title'=>'Fundación de Antropologia Forense de Guatemala : Forensic Anthropology Foundation of Guatemala.',
        'original_urls'=>['http://www.fafg.org']},
      {
        'id'=>'7038489',
        'title'=>'Fundación de Ayuda Social de las Iglesias Cristianas',
        'original_urls'=>['http://www.fasic.org/']},
      {
        'id'=>'7038487',
        'title'=>'Gabinete de Assessoria Jurídica as Organizaçoes Populares',
        'original_urls'=>['http://www.gajop.org.br/']},
      {
        'id'=>'7038744',
        'title'=>'Galilee Society',
        'original_urls'=>['http://www.gal-soc.org/']},
      {
        'id'=>'8229614',
        'title'=>'Generación Y',
        'original_urls'=>['http://www.desdecuba.com/generaciony/']},
      {
        'id'=>'7038689',
        'title'=>'Ghana Center for Democratic Development',
        'original_urls'=>['http://www.cddghana.org/']},
      {
        'id'=>'7038608',
        'title'=>'Global Alliance against Traffic in Women',
        'original_urls'=>['http://www.gaatw.org/']},
      {
        'id'=>'7038800',
        'title'=>'Global Witness',
        'original_urls'=>['http://www.globalwitness.org/']},
      {
        'id'=>'7905317',
        'title'=>'Greensboro Truth & Community Reconciliation Project',
        'original_urls'=>['http://www.gtcrp.org/']},
      {
        'id'=>'7837629',
        'title'=>'Greensboro Truth & Reconciliation Commission : seeking truth, working for reconciliation /',
        'original_urls'=>['http://www.greensborotrc.org/']},
      {
        'id'=>'7799772',
        'title'=>'HaMoked--Center for the Defence of the Individual',
        'original_urls'=>['http://www.hamoked.org/']},
      {
        'id'=>'7038562',
        'title'=>'Habitat International Coalition',
        'original_urls'=>['http://www.hic-net.org/']},
      {
        'id'=>'7038509',
        'title'=>'Hakielimu',
        'original_urls'=>['http://www.hakielimu.org/']},
      {
        'id'=>'7038259',
        'title'=>'Hayastani Hanrapetutʻyan Mardu Irakunkʻneri Pashtpan',
        'original_urls'=>['http://ombuds.am/main/']},
      {
        'id'=>'7905623',
        'title'=>'Hayʼat al-Inṣāf wa-al-Muṣālaḥah',
        'original_urls'=>['http://www.ier.ma/']},
      {
        'id'=>'7038252',
        'title'=>'Hellenic Republic, National Commission for Human Rights',
        'original_urls'=>['http://www.nchr.gr/']},
      {
        'id'=>'7803400',
        'title'=>'Helsinki Citizens\' Assembly Vanadzor Office',
        'original_urls'=>['http://www.hcav.am/']},
      {
        'id'=>'8961341',
        'title'=>'Helsinki Committee for Human Rights in Serbia',
        'original_urls'=>['http://www.helsinki.org.rs/']},
      {
        'id'=>'7038499',
        'title'=>'Héritiers de la Justice',
        'original_urls'=>['http://www.heritiers.org/']},
      {
        'id'=>'7732064',
        'title'=>'Human Rights Commission [Zambia]',
        'original_urls'=>['http://www.hrc.org.zm/']},
      {
        'id'=>'7038399',
        'title'=>'Human Rights Commission of Malaysia : Suruhanjaya Hak Asasi Manusia Malaysia.',
        'original_urls'=>['http://www.suhakam.org.my/']},
      {
        'id'=>'5533057',
        'title'=>'Human Rights Commission of Pakistan',
        'original_urls'=>['http://www.hrcp-web.org/']},
      {
        'id'=>'7732067',
        'title'=>'Human Rights Commission of Sri Lanka',
        'original_urls'=>['http://hrcsl.lk/']},
      {
        'id'=>'7732066',
        'title'=>'Human Rights Commission of the Maldives',
        'original_urls'=>['http://www.hrcm.org.mv/']},
      {
        'id'=>'7038417',
        'title'=>'Human Rights Commission, New Zealand',
        'original_urls'=>['http://www.hrc.co.nz/']},
      {
        'id'=>'7834145',
        'title'=>'Human Rights Concern Eritrea',
        'original_urls'=>['http://hrc-eritrea.org/']},
      {
        'id'=>'7038544',
        'title'=>'Human Rights Congress for Bangladesh Minorities',
        'original_urls'=>['http://www.hrcbm.org/']},
      {
        'id'=>'7038644',
        'title'=>'Human Rights Council of Australia',
        'original_urls'=>['http://www.hrca.org.au/']},
      {
        'id'=>'7885006',
        'title'=>'Human Rights Education Institute of Burma',
        'original_urls'=>['http://www.hreib.com/']},
      {
        'id'=>'5355337',
        'title'=>'Human Rights First',
        'original_urls'=>['http://www.humanrightsfirst.org/']},
      {
        'id'=>'7890712',
        'title'=>'Human Rights First Society',
        'original_urls'=>['http://hrfssaudiarabia.org/']},
      {
        'id'=>'7038266',
        'title'=>'Human Rights Law Network',
        'original_urls'=>['http://www.hrln.org/hrln/']},
      {
        'id'=>'8959998',
        'title'=>'Human Rights Press Point',
        'original_urls'=>['http://www.humanrightspoint.si/']},
      {
        'id'=>'7038429',
        'title'=>'I-India',
        'original_urls'=>['http://www.i-indiaonline.com/']},
      {
        'id'=>'7038498',
        'title'=>'IDASA',
        'original_urls'=>['http://www.idasa.org/','http://www.idasa.org.za/']},
      {
        'id'=>'7038527',
        'title'=>'INDICT',
        'original_urls'=>['http://www.indict.org.uk/index.php']},
      {
        'id'=>'7038351',
        'title'=>'Independent Commission for Human Rights',
        'original_urls'=>['http://www.ichr.ps/']},
      {
        'id'=>'7038653',
        'title'=>'Indeso mujer',
        'original_urls'=>['http://www.indesomujer.org.ar/']},
      {
        'id'=>'7038273',
        'title'=>'Indigenous Peoples Council on Biocolonialism',
        'original_urls'=>['http://www.ipcb.org/']},
      {
        'id'=>'7038618',
        'title'=>'Indigenous Peoples\' Center for Documentation, Research and Information',
        'original_urls'=>['http://www.docip.org/']},
      {
        'id'=>'9186324',
        'title'=>'Indignación',
        'original_urls'=>['http://indignacion.org.mx/']},
      {
        'id'=>'8964437',
        'title'=>'Informat︠s︡ionno-analiticheskiĭ t︠s︡entr "Sova"',
        'original_urls'=>['http://www.sova-center.ru/']},
      {
        'id'=>'8953012',
        'title'=>'Inimõiguste keskus',
        'original_urls'=>['http://humanrights.ee/']},
      {
        'id'=>'7822594',
        'title'=>'Institute for Justice and Reconciliation',
        'original_urls'=>['http://www.ijr.org.za/']},
      {
        'id'=>'8257091',
        'title'=>'Instituto Espacio para la Memoria',
        'original_urls'=>['http://www.institutomemoria.org.ar/index.html']},
      {
        'id'=>'9051345',
        'title'=>'Instituto Latinoamericano para una Sociedad y un Derecho Alternativos',
        'original_urls'=>['http://ilsa.org.co:81/']},
      {
        'id'=>'9160225',
        'title'=>'Instituto de Defensa Legal - IDL',
        'original_urls'=>['http://www.idl.org.pe/']},
      {
        'id'=>'7038459',
        'title'=>'International Campaign for Tibet',
        'original_urls'=>['http://savetibet.org/']},
      {
        'id'=>'7819711',
        'title'=>'International Coalition for the Responsibility to Protect',
        'original_urls'=>['http://www.responsibilitytoprotect.org/']},
      {
        'id'=>'5571653',
        'title'=>'International Commission of Jurists',
        'original_urls'=>['http://www.icj.org/']},
      {
        'id'=>'7038540',
        'title'=>'International Commission on Missing Persons',
        'original_urls'=>['http://www.ic-mp.org/']},
      {
        'id'=>'7904970',
        'title'=>'International Committee Against Stoning',
        'original_urls'=>['http://stopstonningnow.com/']},
      {
        'id'=>'7038371',
        'title'=>'International Committee for Democracy in Cuba',
        'original_urls'=>['http://icdcprague.org/']},
      {
        'id'=>'7038550',
        'title'=>'International Committee of Solidarity for Political Prisoners in Tunisia',
        'original_urls'=>['http://membres.lycos.fr/polprisoners/icsppten.htm']},
      {
        'id'=>'9130439',
        'title'=>'International Criminal Tribunal for Rwanda',
        'original_urls'=>['http://www.unictr.org/']},
      {
        'id'=>'5316489',
        'title'=>'International Crisis Group',
        'original_urls'=>['http://www.crisisgroup.org/']},
      {
        'id'=>'7038723',
        'title'=>'International Federation of Health and Human Rights Organisations',
        'original_urls'=>['http://www.ifhhro.org/']},
      {
        'id'=>'7890675',
        'title'=>'International Federation of Iranian Refugees',
        'original_urls'=>['http://www.hambastegi.org/']},
      {
        'id'=>'7038815',
        'title'=>'International Gay and Lesbian Human Rights Commission',
        'original_urls'=>['http://www.iglhrc.org/']},
      {
        'id'=>'7038721',
        'title'=>'International League for Human Rights',
        'original_urls'=>['http://www.ilhr.org/index.html']},
      {
        'id'=>'7038807',
        'title'=>'International Service for Human Rights',
        'original_urls'=>['http://www.ishr.ch/']},
      {
        'id'=>'7038287',
        'title'=>'International Society for Human Rights',
        'original_urls'=>['http://www.ishr.org/']},
      {
        'id'=>'7038537',
        'title'=>'International Work Group for Indigenous Affairs',
        'original_urls'=>['http://www.iwgia.org/']},
      {
        'id'=>'7038286',
        'title'=>'Invisible Tibet : Woeser\'s blog.',
        'original_urls'=>['http://woeser.middle-way.net/']},
      {
        'id'=>'7038648',
        'title'=>'Iran Human Rights Documentation Center',
        'original_urls'=>['http://www.iranhrdc.org/httpdocs/index.htm']},
      {
        'id'=>'7822959',
        'title'=>'Iran Human Rights Voice',
        'original_urls'=>['http://www.ihrv.org/']},
      {
        'id'=>'7799940',
        'title'=>'Iraq Foundation',
        'original_urls'=>['http://www.iraqfoundation.org/']},
      {
        'id'=>'7800011',
        'title'=>'Iraqi Human Rights Group',
        'original_urls'=>['http://www.irag.org.uk/eindex.php']},
      {
        'id'=>'7038803',
        'title'=>'Islamic Human Rights Commission',
        'original_urls'=>['http://www.ihrc.org.uk/']},
      {
        'id'=>'8539972',
        'title'=>'Íslandsdeild Amnesty International',
        'original_urls'=>['http://www.amnesty.is/']},
      {
        'id'=>'7905840',
        'title'=>'İnsan Hakları Ortak Platformu : Human Rights Joint Platform.',
        'original_urls'=>['http://www.ihop.org.tr/']},
      {
        'id'=>'7885570',
        'title'=>'Jamʻīyat Shabāb al-Baḥrayn li-Ḥuqūq al-Insān',
        'original_urls'=>['http://byshr.org/']},
      {
        'id'=>'7038622',
        'title'=>'Jesuit Refugee Service',
        'original_urls'=>['http://www.jrs.net/']},
      {
        'id'=>'7819678',
        'title'=>'Jesuit Refugee Service/USA',
        'original_urls'=>['http://www.jrsusa.org/']},
      {
        'id'=>'7038543',
        'title'=>'Judicial System Monitoring Programme',
        'original_urls'=>['http://www.jsmp.minihub.org/']},
      {
        'id'=>'7809241',
        'title'=>'Jumma Peoples Network UK',
        'original_urls'=>['http://www.jpnuk.org.uk/']},
      {
        'id'=>'7038486',
        'title'=>'Justiça Global',
        'original_urls'=>['http://www.global.org.br/']},
      {
        'id'=>'9066101',
        'title'=>'Kefayah',
        'original_urls'=>['http://harakamasria.org/']},
      {
        'id'=>'7038549',
        'title'=>'Kenya Human Rights Commission',
        'original_urls'=>['http://www.khrc.or.ke/']},
      {
        'id'=>'7038494',
        'title'=>'Kenya National Commission on Human Rights',
        'original_urls'=>['http://www.knchr.org/']},
      {
        'id'=>'7038683',
        'title'=>'Kgeikani Kweni, First People of the Kalahari',
        'original_urls'=>['http://www.iwant2gohome.org']},
      {
        'id'=>'8959905',
        'title'=>'Komitet pravnlka za ljudska prava',
        'original_urls'=>['http://www.yucom.org.rs/']},
      {
        'id'=>'7038400',
        'title'=>'Komnas HAM Indonesia',
        'original_urls'=>['http://www.komnasham.go.id/']},
      {
        'id'=>'7038604',
        'title'=>'Kosovakosovo.com',
        'original_urls'=>['http://www.kosovakosovo.com/']},
      {
        'id'=>'7038797',
        'title'=>'Kurdish Human Rights Project',
        'original_urls'=>['http://www.khrp.org/']},
      {
        'id'=>'7038462',
        'title'=>'Kurdish Women\'s Rights Watch',
        'original_urls'=>['http://www.kwrw.org/']},
      {
        'id'=>'7038438',
        'title'=>'Kuru Family of Organisations',
        'original_urls'=>['http://www.kuru.co.bw/']},
      {
        'id'=>'7038542',
        'title'=>'Kyrgyz Committee for Human Rights',
        'original_urls'=>['http://www.kchr.org/']},
      {
        'id'=>'7038404',
        'title'=>'La Defensoria de los Habitantes',
        'original_urls'=>['http://www.dhr.go.cr/']},
      {
        'id'=>'8412117',
        'title'=>'Land Center for Human Rights',
        'original_urls'=>['http://www.lchr-eg.org/']},
      {
        'id'=>'7038655',
        'title'=>'Latin American and Caribbean Committee for the Defense of Women\'s Rights',
        'original_urls'=>['http://www.cladem.org/']},
      {
        'id'=>'7038657',
        'title'=>'Latvian Centre for Human Rights',
        'original_urls'=>['http://www.humanrights.org.lv/html/']},
      {
        'id'=>'7839371',
        'title'=>'Law & Society Trust',
        'original_urls'=>['http://www.lawandsocietytrust.org/','http://www.lawandsocietytrust.org/web/']},
      {
        'id'=>'7038680',
        'title'=>'Legal and Human Rights Centre',
        'original_urls'=>['http://www.humanrights.or.tz/']},
      {
        'id'=>'8446737',
        'title'=>'Lembaga Studi dan Advokasi Masyarakat',
        'original_urls'=>['http://www.elsam.or.id/new/index.php']},
      {
        'id'=>'7890025',
        'title'=>'Ligue algerienne pour la defense des droits de l\'homme',
        'original_urls'=>['http://www.algerie-laddh.org/']},
      {
        'id'=>'7038685',
        'title'=>'Ligue burundaise des droits de l\'homme',
        'original_urls'=>['http://www.ligue-iteka.africa-web.org/index.php3']},
      {
        'id'=>'7813807',
        'title'=>'MAP Foundation',
        'original_urls'=>['http://www.mapfoundationcm.org/']},
      {
        'id'=>'7038819',
        'title'=>'Madre',
        'original_urls'=>['http://madre.org/']},
      {
        'id'=>'7038412',
        'title'=>'Malawi Human Rights Commission',
        'original_urls'=>['http://www.malawihumanrightscommission.org/']},
      {
        'id'=>'8459920',
        'title'=>'Malawi Human Rights Resource Centre',
        'original_urls'=>['http://www.humanrights.mw/']},
      {
        'id'=>'8860683',
        'title'=>'Mardu iravunkʻnerě Hayastanum',
        'original_urls'=>['http://www.hra.am/']},
      {
        'id'=>'8414984',
        'title'=>'Markaz Hishām Mubārak lil-Qānūn',
        'original_urls'=>['http://www.hmlc-egy.org/']},
      {
        'id'=>'7824247',
        'title'=>'Markaz al-Tawthīq wa-al-Iʻlām wa-al-Takwīn fī Majāl Ḥuqūq al-Insān',
        'original_urls'=>['http://www.cdifdh.org.ma/']},
      {
        'id'=>'7038411',
        'title'=>'Mauritius National Human Rights Commission',
        'original_urls'=>['http://www.gov.mu/portal/site/nhrcsite']},
      {
        'id'=>'7890773',
        'title'=>'Mazlumder : İnsan Hakları ve Mazlumlar için Dayanışma Derneği = The Association of Human Rights and Solidarity for Oppressed People.',
        'original_urls'=>['http://www.mazlumder.org/']},
      {
        'id'=>'7033263',
        'title'=>'Media Foundation for West Africa',
        'original_urls'=>['http://www.mediafound.org/']},
      {
        'id'=>'9085457',
        'title'=>'Memoria Abierta',
        'original_urls'=>['http://www.memoriaabierta.org.ar/']},
      {
        'id'=>'7038760',
        'title'=>'Mezan Center for Human Rights',
        'original_urls'=>['http://www.mezan.org/']},
      {
        'id'=>'7038360',
        'title'=>'Minority Rights Group International',
        'original_urls'=>['http://www.minorityrights.org/']},
      {
        'id'=>'7038398',
        'title'=>'Mongol Ulsyn Khu̇niĭ Ėrkhiĭn U̇ndėsniĭ Komiss',
        'original_urls'=>['http://www.mn-nhrc.org/']},
      {
        'id'=>'7038669',
        'title'=>'Moskovskai︠a︡ khelʹsinkskai︠a︡ gruppa',
        'original_urls'=>['http://www.mhg.ru/']},
      {
        'id'=>'7038250',
        'title'=>'Mouvement contre les armes légères en Afrique de l\'Ouest',
        'original_urls'=>['http://www.malao.org/']},
      {
        'id'=>'9051461',
        'title'=>'Movimento Nacional dos Direitos Humanos',
        'original_urls'=>['http://www.mndh.org.br/']},
      {
        'id'=>'7038651',
        'title'=>'Movimento dos Trabalhadores Rurais sem Terra',
        'original_urls'=>['http://www.mst.org.br/']},
      {
        'id'=>'9094742',
        'title'=>'Munaẓẓamah al-Maghribīyah li-Ḥuqūq al-Insān : Organisation Marocaine des Droits Humains.',
        'original_urls'=>['http://www.omdh.org/']},
      {
        'id'=>'8415142',
        'title'=>'Munaẓẓamah al-ʻArabīyah lil-Iṣlāḥ al-Jināʼī',
        'original_urls'=>['http://www.aproarab.org/']},
      {
        'id'=>'8415370',
        'title'=>'Muʼassasat al-Marʼah al-Jadīdah',
        'original_urls'=>['http://nwrcegypt.org/']},
      {
        'id'=>'8263078',
        'title'=>'NAMRIGHTS',
        'original_urls'=>['http://www.nshr.org.na/']},
      {
        'id'=>'7193114',
        'title'=>'NCHRO : National Confederation of Human Rights Organizations.',
        'original_urls'=>['http://nchro.org/']},
      {
        'id'=>'7667863',
        'title'=>'NGO Coordination Committee for Iraq : Lajnat Tansīq al-Munaẓẓamāt Ghayr al-Ḥukūmiyah fī al-ʻIrāq.',
        'original_urls'=>['http://www.ncciraq.org/']},
      {
        'id'=>'7038737',
        'title'=>'National Campaign on Dalit Human Rights',
        'original_urls'=>['http://www.ncdhr.org.in/']},
      {
        'id'=>'7038373',
        'title'=>'National Centre for Human Rights [Jordan]',
        'original_urls'=>['http://www.nchr.org.jo/']},
      {
        'id'=>'7038405',
        'title'=>'National Council for Human Rights [Egypt]',
        'original_urls'=>['http://www.nchregypt.org/']},
      {
        'id'=>'7038352',
        'title'=>'National Human Rights Commission of Korea',
        'original_urls'=>['http://www.humanrights.go.kr/english/index.jsp']},
      {
        'id'=>'7038263',
        'title'=>'National Human Rights Commission, Nepal',
        'original_urls'=>['http://www.nhrcnepal.org/']},
      {
        'id'=>'7038633',
        'title'=>'National Human Rights Commission, New Delhi, India',
        'original_urls'=>['http://www.nhrc.nic.in/']},
      {
        'id'=>'7038381',
        'title'=>'National Human Rights Commission, Nigeria',
        'original_urls'=>['http://www.nigeriarights.gov.ng/']},
      {
        'id'=>'7732060',
        'title'=>'National Human Rights Committee : Lajnah al-Waṭanīyah li-Ḥuqūq al-Insān.',
        'original_urls'=>['http://www.nhrc-qa.org/']},
      {
        'id'=>'9077930',
        'title'=>'National Organization for Defending Rights and Freedoms',
        'original_urls'=>['http://hoodonline.org/']},
      {
        'id'=>'8455680',
        'title'=>'National Protection Working Group (NWPG)',
        'original_urls'=>['http://www.fohridnetwork.org/']},
      {
        'id'=>'8179176',
        'title'=>'National Unity and Reconciliation Commission',
        'original_urls'=>['http://www.nurc.gov.rw/']},
      {
        'id'=>'7731591',
        'title'=>'Nemzeti és Etnikai Kisebbségi Jogok Országgyűlési Biztosa',
        'original_urls'=>['http://www.kisebbsegiombudsman.hu/']},
      {
        'id'=>'7033268',
        'title'=>'Network Movement for Justice and Development',
        'original_urls'=>['http://www.nmjd.org/']},
      {
        'id'=>'7928882',
        'title'=>'Network of Concerned Historians',
        'original_urls'=>['http://www.concernedhistorians.org/']},
      {
        'id'=>'7038789',
        'title'=>'New Tactics in Human Rights',
        'original_urls'=>['http://www.newtactics.org/']},
      {
        'id'=>'7038409',
        'title'=>'Northern Ireland Human Rights Commission',
        'original_urls'=>['http://www.nihrc.org/']},
      {
        'id'=>'8928169',
        'title'=>'Not On Our Watch',
        'original_urls'=>['http://notonourwatchproject.org/']},
      {
        'id'=>'9006551',
        'title'=>'Nuba Survival Foundation',
        'original_urls'=>['http://www.nubasurvival.com/']},
      {
        'id'=>'8011158',
        'title'=>'OMAL : Observatorio de Multinacionales en América  Latina.',
        'original_urls'=>['http://www.omal.info/www/sommaire.php3']},
      {
        'id'=>'9085451',
        'title'=>'Observatorio Ciudadano',
        'original_urls'=>['http://www.observatorio.cl/']},
      {
        'id'=>'7038397',
        'title'=>'Office of the National Human Rights Commission of Thailand',
        'original_urls'=>['http://www.nhrc.or.th/']},
      {
        'id'=>'7038410',
        'title'=>'Office of the Ombudsman [Namibia]',
        'original_urls'=>['http://www.ombudsman.org.na/']},
      {
        'id'=>'7731800',
        'title'=>'Office of the Ombudsman of Trinidad and Tobago',
        'original_urls'=>['http://www.ombudsman.gov.tt/']},
      {
        'id'=>'7839243',
        'title'=>'Oficina del Procurador del Ciudadano de Puerto Rico',
        'original_urls'=>['http://www.ombudsmanpr.com/']},
      {
        'id'=>'7038255',
        'title'=>'Ombudsman Republike Srpske--zaštitnik ljudskih prava',
        'original_urls'=>['http://www.ombudsmen.rs.ba/']},
      {
        'id'=>'7038257',
        'title'=>'Ombudsman [Azerbaijan]',
        'original_urls'=>['http://ombudsman.gov.az/']},
      {
        'id'=>'7038649',
        'title'=>'One Million Signatures Demanding Changes to Discriminatory Laws',
        'original_urls'=>['http://www.we-change.org/']},
      {
        'id'=>'7888713',
        'title'=>'Organización Argentina de Jóvenes para las Naciones Unidas : OAJNU.',
        'original_urls'=>['http://www.oajnu.org/']},
      {
        'id'=>'7038659',
        'title'=>'Organizat︠s︡ii︠a︡ Drom',
        'original_urls'=>['http://drom-vidin.org/']},
      {
        'id'=>'7038338',
        'title'=>'Other Russia',
        'original_urls'=>['http://www.theotherrussia.org/']},
      {
        'id'=>'9133514',
        'title'=>'PROVEA : Programa Venezolano de Educación-Acción en Derechos Humanos.',
        'original_urls'=>['http://www.derechos.org.ve/']},
      {
        'id'=>'7038632',
        'title'=>'Pakistan International Human Rights Organization',
        'original_urls'=>['http://www.pihro.org/']},
      {
        'id'=>'7038792',
        'title'=>'Palestinian Center for Human Rights',
        'original_urls'=>['http://www.pchrgaza.org/']},
      {
        'id'=>'7960030',
        'title'=>'Paz con Dignidad',
        'original_urls'=>['http://www.pazcondignidad.org/']},
      {
        'id'=>'7038814',
        'title'=>'Peace Brigades International : making space for peace.',
        'original_urls'=>['http://www.peacebrigades.org/']},
      {
        'id'=>'9066303',
        'title'=>'Persian2English',
        'original_urls'=>['http://persian2english.com/']},
      {
        'id'=>'4191511',
        'title'=>'Physicians for Human Rights',
        'original_urls'=>['http://physiciansforhumanrights.org/']},
      {
        'id'=>'9097468',
        'title'=>'Plataforma Interamericana de Derechos Humanos, Democracia y Desarrollo',
        'original_urls'=>['http://www.pidhdd.org/']},
      {
        'id'=>'8409019',
        'title'=>'Point Pedro Institute of Development.',
        'original_urls'=>['http://pointpedro.org/']},
      {
        'id'=>'8616290',
        'title'=>'Portail de l\'Organisation TAMAYNUT',
        'original_urls'=>['http://tamaynut.org/']},
      {
        'id'=>'7038327',
        'title'=>'Prava li︠u︡dyny v Ukraïni',
        'original_urls'=>['http://www.khpg.org/']},
      {
        'id'=>'7038337',
        'title'=>'Pravovai︠a︡ init︠s︡iativa po Rossii',
        'original_urls'=>['http://www.srji.org/']},
      {
        'id'=>'7038820',
        'title'=>'Privacy International',
        'original_urls'=>['http://www.privacyinternational.org/']},
      {
        'id'=>'7038402',
        'title'=>'Procuraduria de los Derechos Humanos',
        'original_urls'=>['http://www.pdh.org.gt/']},
      {
        'id'=>'7038261',
        'title'=>'Procuraduría para la Defensa de los Derechos Humanos República de Nicaragua--América Central',
        'original_urls'=>['http://www.procuraduriaddhh.gob.ni/']},
      {
        'id'=>'7038254',
        'title'=>'Pučki pravobranitelj : Ombudsman.',
        'original_urls'=>['http://www.ombudsman.hr/']},
      {
        'id'=>'7904717',
        'title'=>'Pukhan minjuhwa net\'ŭwŏk\'ŭ : Network for North Korean Democracy and Human Rights (NKnet).',
        'original_urls'=>['http://www.nknet.org/']},
      {
        'id'=>'8930254',
        'title'=>'Qūwat al-ʻAmal li-Munāhaḍat al-Taʻdhīb',
        'original_urls'=>['http://against-torture.net/']},
      {
        'id'=>'7038665',
        'title'=>'RPHA "Belaruski khelʹsinkski kamitėt"',
        'original_urls'=>['http://www.belhelcom.org/']},
      {
        'id'=>'7038793',
        'title'=>'Rabbis for Human Rights',
        'original_urls'=>['http://www.rhr.org.il/']},
      {
        'id'=>'7038710',
        'title'=>'Ramallah Center for Human Rights Studies',
        'original_urls'=>['http://www.rchrs.org/']},
      {
        'id'=>'9085465',
        'title'=>'Rede Social de Justiça e Direitos Humanos',
        'original_urls'=>['http://www.social.org.br/']},
      {
        'id'=>'9065961',
        'title'=>'Regional Watch for Human Rights',
        'original_urls'=>['http://blog.rwhr.org/']},
      {
        'id'=>'7038496',
        'title'=>'Rencontre africaine pour la défense des droits de l\'homme',
        'original_urls'=>['http://raddho.org/','http://www.raddho.africa-web.org/']},
      {
        'id'=>'8961190',
        'title'=>'Republika Makedonija naroden pravobranitel Ombudsman',
        'original_urls'=>['http://www.ombudsman.mk/']},
      {
        'id'=>'7033269',
        'title'=>'Réseau des journalistes pour les droits de l\'homme',
        'original_urls'=>['http://www.rjdh-niger.org/']},
      {
        'id'=>'7038650',
        'title'=>'Réseau national de défense des droits humains--RNDDH',
        'original_urls'=>['http://www.rnddh.org/index.php3']},
      {
        'id'=>'8953033',
        'title'=>'Rrjeti i Grupeve të Grave të Kosovës',
        'original_urls'=>['http://www.womensnetwork.org/']},
      {
        'id'=>'7038274',
        'title'=>'Russian Association of Indigenous Peoples of the North, Siberia and the Far East',
        'original_urls'=>['http://www.raipon.info/','http://www.raipon.org/']},
      {
        'id'=>'8960390',
        'title'=>'Satellite Sentinel Project',
        'original_urls'=>['http://www.satsentinel.org/']},
      {
        'id'=>'7038418',
        'title'=>'Sdružení Dženo',
        'original_urls'=>['http://www.dzeno.cz/']},
      {
        'id'=>'8448889',
        'title'=>'Sección Peruana de Amnistía Internacional',
        'original_urls'=>['http://www.amnistia.org.pe/']},
      {
        'id'=>'7038626',
        'title'=>'Shan Women\'s Action Network',
        'original_urls'=>['http://www.shanwomen.org/']},
      {
        'id'=>'8163119',
        'title'=>'Shirkat Gah : women\'s resource centre.',
        'original_urls'=>['http://www.shirkatgah.org/']},
      {
        'id'=>'7813804',
        'title'=>'Sin Fronteras IAP',
        'original_urls'=>['http://www.sinfronteras.org.mx/']},
      {
        'id'=>'7033266',
        'title'=>'Sokwanele',
        'original_urls'=>['http://www.sokwanele.com/']},
      {
        'id'=>'7033267',
        'title'=>'Solidarity Peace Trust',
        'original_urls'=>['http://www.solidaritypeacetrust.org/']},
      {
        'id'=>'8502012',
        'title'=>'South Africa Truth and Reconciliation Commission',
        'original_urls'=>['http://www.justice.gov.za/trc/']},
      {
        'id'=>'7038383',
        'title'=>'South African Human Rights Commission',
        'original_urls'=>['http://www.sahrc.org.za/']},
      {
        'id'=>'5533251',
        'title'=>'South Asia Forum for Human Rights',
        'original_urls'=>['http://www.safhr.org/']},
      {
        'id'=>'8952643',
        'title'=>'Srebrenica.ba',
        'original_urls'=>['http://www.srebrenica.ba/']},
      {
        'id'=>'7038455',
        'title'=>'Students for a Free Tibet',
        'original_urls'=>['http://studentsforafreetibet.org/index.php']},
      {
        'id'=>'7033270',
        'title'=>'Suara Rakyat Malaysia',
        'original_urls'=>['http://www.suaram.net/']},
      {
        'id'=>'7038420',
        'title'=>'Survivor Corps',
        'original_urls'=>['http://www.survivorcorps.org/']},
      {
        'id'=>'7038679',
        'title'=>'Tanzania Gender Networking Programme',
        'original_urls'=>['http://www.tgnp.org/']},
      {
        'id'=>'7038541',
        'title'=>'Tapol',
        'original_urls'=>['http://tapol.gn.apc.org/']},
      {
        'id'=>'8775601',
        'title'=>'Terra de Direitos : organização  de direitos humanos.',
        'original_urls'=>['http://terradedireitos.org.br/']},
      {
        'id'=>'7038784',
        'title'=>'The Advocates for Human Rights',
        'original_urls'=>['http://www.theadvocatesforhumanrights.org/']},
      {
        'id'=>'7771968',
        'title'=>'The Association for Civil Rights in Israel',
        'original_urls'=>['http://www.acri.org.il/']},
      {
        'id'=>'7038386',
        'title'=>'The Burma Campaign UK',
        'original_urls'=>['http://www.burmacampaign.org.uk/']},
      {
        'id'=>'7038358',
        'title'=>'The Center for Democracy & Human Rights in Saudi Arabia',
        'original_urls'=>['http://www.cdhr.info/']},
      {
        'id'=>'7038724',
        'title'=>'The Center for Justice and Accountability',
        'original_urls'=>['http://www.cja.org/']},
      {
        'id'=>'7800014',
        'title'=>'The Committee for the Defense of Human Rights in the Arabian Peninsula',
        'original_urls'=>['http://cdhrap.net/']},
      {
        'id'=>'8415331',
        'title'=>'The Egyptian Association for Community Participation Enhancement',
        'original_urls'=>['http://www.en.mosharka.org/']},
      {
        'id'=>'8460249',
        'title'=>'The Equal Rights Trust',
        'original_urls'=>['http://www.equalrightstrust.org/']},
      {
        'id'=>'8408294',
        'title'=>'The Initiative for an Open Arab Internet',
        'original_urls'=>['http://openarab.net/en/']},
      {
        'id'=>'7815764',
        'title'=>'The International Network for the Rights of Female Victims of Violence in Pakistan (INRFVVP)',
        'original_urls'=>['http://ecumene.org/INRFVVP/']},
      {
        'id'=>'7038681',
        'title'=>'The Lawyers Centre for Legal Assistance',
        'original_urls'=>['http://www.lawcla.org/']},
      {
        'id'=>'7038780',
        'title'=>'The Palestinian Human Rights Monitoring Group',
        'original_urls'=>['http://www.phrmg.org/']},
      {
        'id'=>'7901541',
        'title'=>'The Rights Exposure Project',
        'original_urls'=>['http://therightsexposureproject.com/']},
      {
        'id'=>'7038467',
        'title'=>'ThinkCentre.org',
        'original_urls'=>['http://www.thinkcentre.org/']},
      {
        'id'=>'7038458',
        'title'=>'TibetInfoNet',
        'original_urls'=>['http://www.tibetinfonet.net/']},
      {
        'id'=>'7038456',
        'title'=>'Tibetan Centre for Human Rights and Democracy',
        'original_urls'=>['http://www.tchrd.org/']},
      {
        'id'=>'7033264',
        'title'=>'Transition Monitoring Group, Nigeria',
        'original_urls'=>['http://www.tmgnigeria.org/']},
      {
        'id'=>'4751601',
        'title'=>'Transparency International',
        'original_urls'=>['http://www.transparency.org/']},
      {
        'id'=>'8281930',
        'title'=>'Truth and Reconciliation Commission of Liberia',
        'original_urls'=>['http://www.trcofliberia.org/']},
      {
        'id'=>'7900280',
        'title'=>'Truth and Reconciliation Commission, Republic of Korea : Chinsil, Hwahae rŭl wihan Kwagŏsa Chŏngni Wiwŏnhoe.',
        'original_urls'=>['http://jinsil.go.kr/']},
      {
        'id'=>'9177497',
        'title'=>'Truth, Justice and Reconciliation Commission of Kenya',
        'original_urls'=>['http://www.tjrckenya.org/']},
      {
        'id'=>'7038349',
        'title'=>'Türkiye İnsan Hakları Vakfı',
        'original_urls'=>['http://www.tihv.org.tr/']},
      {
        'id'=>'7038439',
        'title'=>'T︠S︡entr informat︠s︡iï ta dokumentat︠s︡iï krymsʹkykh tatar',
        'original_urls'=>['http://www.cidct.org.ua/en/']},
      {
        'id'=>'7971722',
        'title'=>'Uganda Coalition on the International Criminal Court',
        'original_urls'=>['http://www.ucicc.org/']},
      {
        'id'=>'7732065',
        'title'=>'Uganda Human Rights Commission',
        'original_urls'=>['http://www.uhrc.ug/']},
      {
        'id'=>'8602539',
        'title'=>'Uluslararası Af Örgütü--Türkiye',
        'original_urls'=>['http://www.amnesty.org.tr/']},
      {
        'id'=>'8966262',
        'title'=>'Unity for Human Rights and Democracy Toronto',
        'original_urls'=>['http://andnettoronto.blogspot.com/']},
      {
        'id'=>'7038247',
        'title'=>'University Teachers for Human Rights',
        'original_urls'=>['http://www.uthr.org/index.html']},
      {
        'id'=>'7038602',
        'title'=>'Unrepresented Nations and Peoples Organization',
        'original_urls'=>['http://www.unpo.org/']},
      {
        'id'=>'7038253',
        'title'=>'Veřejný ochránce práv',
        'original_urls'=>['http://www.ochrance.cz/']},
      {
        'id'=>'8961305',
        'title'=>'Vi︠a︡sna pravaabaronchy tsėntr',
        'original_urls'=>['http://spring96.org/']},
      {
        'id'=>'7038497',
        'title'=>'Voix des Sans Voix',
        'original_urls'=>['http://www.vsv-rdc.com/','http://www.congonline.com/vsv/']},
      {
        'id'=>'7038258',
        'title'=>'Volksanwaltschaft',
        'original_urls'=>['http://volksanwaltschaft.gv.at/','http://www.volksanw.gv.at/']},
      {
        'id'=>'9159182',
        'title'=>'WOREC Nepal',
        'original_urls'=>['http://worecnepal.org/']},
      {
        'id'=>'8438858',
        'title'=>'Wa7damasrya',
        'original_urls'=>['http://www.wa7damasrya.blogspot.com/']},
      {
        'id'=>'7952274',
        'title'=>'Women Journalists Without Chains : Munaẓẓamat Ṣaḥafīyāt Bilā Quyūd.',
        'original_urls'=>['http://www.womenpress.net/']},
      {
        'id'=>'5550172',
        'title'=>'Women Living Under Muslim Laws : WLUML = Femmes Sous Lois Musulmanes.',
        'original_urls'=>['http://www.wluml.org/english/index.shtml']},
      {
        'id'=>'7038451',
        'title'=>'Women for Afghan Women',
        'original_urls'=>['http://www.womenforafghanwomen.org/']},
      {
        'id'=>'7038350',
        'title'=>'Women for Women\'s Human Rights',
        'original_urls'=>['http://www.wwhr.org/']},
      {
        'id'=>'9187439',
        'title'=>'Women\'s Initiatives for Gender Justice',
        'original_urls'=>['http://www.iccwomen.org/']},
      {
        'id'=>'6952107',
        'title'=>'World Organisation Against Torture',
        'original_urls'=>['http://www.omct.org/']},
      {
        'id'=>'7952294',
        'title'=>'Yemeni Human Rights Network',
        'original_urls'=>['http://yhrn.org/']},
      {
        'id'=>'9079995',
        'title'=>'Yemeni Organization for Defending Rights and Democratic Freedom',
        'original_urls'=>['http://www.hurryat.org/']},
      {
        'id'=>'8379205',
        'title'=>'Yesh Din--volunteers for human rights',
        'original_urls'=>['http://www.yesh-din.org/']},
      {
        'id'=>'7038678',
        'title'=>'Zimbabwe Human Rights NGO Forum',
        'original_urls'=>['http://www.hrforumzim.com/']},
      {
        'id'=>'7038677',
        'title'=>'Zimbabwe Lawyers for Human Rights',
        'original_urls'=>['http://www.zlhr.org.zw/']},
      {
        'id'=>'7038380',
        'title'=>'al-Majlis al-Istishārī li-Ḥuqūq al-Insān : [mawqiʻ intirnit] muʾassasat waṭanīyah lil-nuhūṣ biḥuqūq al-insān wa-ḥimāyatihā = Conseil consultatif des droits de lʹhomme : [site Web] institution nationale pour la protection des driots de lʹhomme.',
        'original_urls'=>['http://www.ccdh.org.ma/']},
      {
        'id'=>'8408166',
        'title'=>'al-Markaz al-Miṣrī li-Ḥuqūq al-Marʾah : [mawqiʻ intirnit].',
        'original_urls'=>['http://ecwronline.org']},
      {
        'id'=>'8541975',
        'title'=>'al-Marṣad al-Yamanī li-Ḥuqūq al-Insān',
        'original_urls'=>['http://www.yohr.org']},
      {
        'id'=>'8929111',
        'title'=>'al-Waʻy al-Miṣrī',
        'original_urls'=>['http://misrdigital.blogspirit.com/']},
      {
        'id'=>'7038805',
        'title'=>'breakthrough',
        'original_urls'=>['http://www.breakthrough.tv/']},
      {
        'id'=>'7038466',
        'title'=>'humanrights.ge : web portal on human rights in Georgia = Veb portali adamianis upʻlebebis mesaxeb.',
        'original_urls'=>['http://www.humanrights.ge/']}]
  }}
end