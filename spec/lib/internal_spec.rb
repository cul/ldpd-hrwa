# -*- encoding : utf-8 -*-
require 'spec_helper'

require 'spreadsheet'

class MockInternalController
  include HRWA::Internal
end

describe 'HRWA::Internal' do     
  it '#site_id_list_spreadsheet' do
    expected_rows = spreadsheet_to_rows( expected_site_id_list_workbook.worksheet 'Site ID List' )
    got_rows      = spreadsheet_to_rows(
      MockInternalController.new.site_id_list_spreadsheet.worksheet 'Site ID List'
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

def expected_site_id_list_workbook
  Spreadsheet.client_encoding = 'UTF-8' 
  workbook = Spreadsheet::Workbook.new
  sheet    = workbook.create_worksheet :name => 'Site ID List'
  
  response = expected_site_id_list_solr_response 
  
  response[ 'response' ][ 'docs' ].each_with_index { | doc, index | 
    sheet[ index, 0 ] = doc[ 'title' ]
    sheet[ index, 1 ] = doc[ 'id'    ]
  }
  
  return workbook
end

def expected_site_id_list_solr_response
  # http://carter.cul.columbia.edu:8080/solr-4/hrwa_blacklight-fsf-unit-test/select/?q=*%3A*&version=2.2&start=0&indent=on&sort=title__facet+asc&wt=ruby&rows=99999&fl=title,id
  return \
{
  'responseHeader'=>{
    'status'=>0,
    'QTime'=>3,
    'params'=>{
      'sort'=>'title__facet asc',
      'version'=>'2.2',
      'fl'=>'title,id',
      'indent'=>'on',
      'wt'=>'ruby',
      'rows'=>'99999',
      'start'=>'0',
      'q'=>'*:*'}},
  'response'=>{'numFound'=>441,'start'=>0,'docs'=>[
      {
        'id'=>'9006313',
        'title'=>'"İnsan Hüquqları XXI ăsr-Azărbaycan" Fondu'},
      {
        'id'=>'7832247',
        'title'=>'5·18 Kinyŏm Chaedan : The May 18 Memorial Foundation.'},
      {
        'id'=>'7038343',
        'title'=>'AFAPREDESA'},
      {
        'id'=>'9085460',
        'title'=>'ANDHES'},
      {
        'id'=>'7885543',
        'title'=>'ASPER : Associazione per la tutela dei diritti umani del popolo eritreo  = Association for the Defense of Human Rights of the Eritrean People.'},
      {
        'id'=>'7038450',
        'title'=>'AWARE'},
      {
        'id'=>'7038393',
        'title'=>'Abuelas de Plaza de Mayo'},
      {
        'id'=>'7876840',
        'title'=>'Access to Justice'},
      {
        'id'=>'8775896',
        'title'=>'Ação Brasileira pela Nutrição e Direitos Humanos'},
      {
        'id'=>'7038763',
        'title'=>'Adalah'},
      {
        'id'=>'8481136',
        'title'=>'Advocacy Forum--Nepal'},
      {
        'id'=>'7038582',
        'title'=>'Afghanistan Independent Human Rights Commission'},
      {
        'id'=>'7038697',
        'title'=>'Africa Internally Displaced Persons Voice'},
      {
        'id'=>'7038465',
        'title'=>'African Centre for Democracy and Human Rights Studies'},
      {
        'id'=>'8971728',
        'title'=>'African Commission on Human and Peoples\' Rights : Commission africaine des droits de l\'homme et des peuples'},
      {
        'id'=>'7038762',
        'title'=>'Al-Dameer Association for Human Rights'},
      {
        'id'=>'7038761',
        'title'=>'Al-Haq'},
      {
        'id'=>'8415458',
        'title'=>'Al-Jamʻīyah al-Waṭanīyah lil-Taghyīr'},
      {
        'id'=>'7038661',
        'title'=>'Albanian Center for Human Rights'},
      {
        'id'=>'7038662',
        'title'=>'Algeria-Watch'},
      {
        'id'=>'8961300',
        'title'=>'Alianța Civică a Romilor din Romania'},
      {
        'id'=>'7038567',
        'title'=>'Amigos de las Mujeres de Juarez'},
      {
        'id'=>'7902541',
        'title'=>'Amman Center for Human Rights Studies : Markaz ʻAmmān li-Dirāsāt Ḥuqūq al-Insān.'},
      {
        'id'=>'5421151',
        'title'=>'Amnesty International'},
      {
        'id'=>'8539187',
        'title'=>'Amnesty International : le site d\'Amnesty Belgique Francophone.'},
      {
        'id'=>'8557219',
        'title'=>'Amnesty International Aotearoa New Zealand'},
      {
        'id'=>'8539206',
        'title'=>'Amnesty International Canada'},
      {
        'id'=>'8540001',
        'title'=>'Amnesty International ČR'},
      {
        'id'=>'8539223',
        'title'=>'Amnesty International Deutschland'},
      {
        'id'=>'8857446',
        'title'=>'Amnesty International European Institutions Office'},
      {
        'id'=>'8539218',
        'title'=>'Amnesty International France'},
      {
        'id'=>'8539234',
        'title'=>'Amnesty International Ghana'},
      {
        'id'=>'8618609',
        'title'=>'Amnesty International Hong Kong'},
      {
        'id'=>'8616335',
        'title'=>'Amnesty International Hrvatske'},
      {
        'id'=>'8602577',
        'title'=>'Amnesty International Luxembourg'},
      {
        'id'=>'8502198',
        'title'=>'Amnesty International Magyarország'},
      {
        'id'=>'8540401',
        'title'=>'Amnesty International Mauritius Section'},
      {
        'id'=>'8455301',
        'title'=>'Amnesty International Moldova'},
      {
        'id'=>'8540054',
        'title'=>'Amnesty International Nepal'},
      {
        'id'=>'8616886',
        'title'=>'Amnesty International Nihon Shibu'},
      {
        'id'=>'8519721',
        'title'=>'Amnesty International Österreich'},
      {
        'id'=>'8540838',
        'title'=>'Amnesty International Philippines'},
      {
        'id'=>'8513355',
        'title'=>'Amnesty International Polska'},
      {
        'id'=>'8557218',
        'title'=>'Amnesty International Schweiz'},
      {
        'id'=>'8585979',
        'title'=>'Amnesty International Sénégal'},
      {
        'id'=>'8540825',
        'title'=>'Amnesty International Slovensko'},
      {
        'id'=>'8602843',
        'title'=>'Amnesty International South Africa'},
      {
        'id'=>'8586037',
        'title'=>'Amnesty International Taiwan = : Guo ji te she zu zhi Taiwan zong hui'},
      {
        'id'=>'9065537',
        'title'=>'Amnesty International [Australia]'},
      {
        'id'=>'8519817',
        'title'=>'Amnesty International [Danmark]'},
      {
        'id'=>'8539378',
        'title'=>'Amnesty International [Finland]'},
      {
        'id'=>'8585473',
        'title'=>'Amnesty International [Ireland]'},
      {
        'id'=>'9055223',
        'title'=>'Amnesty International [Italy]'},
      {
        'id'=>'9065459',
        'title'=>'Amnesty International [Netherlands]'},
      {
        'id'=>'8456088',
        'title'=>'Amnesty International [Norge]'},
      {
        'id'=>'8519768',
        'title'=>'Amnesty International [Svenska sektionen]'},
      {
        'id'=>'8644505',
        'title'=>'Amnesty International [Ukraine]'},
      {
        'id'=>'9055171',
        'title'=>'Amnesty International [United Kingdom]'},
      {
        'id'=>'8540895',
        'title'=>'Amnesty International, F�roya deild'},
      {
        'id'=>'8586003',
        'title'=>'Amnesty International, section Togo'},
      {
        'id'=>'8703322',
        'title'=>'Amnistia Internacional Portugal'},
      {
        'id'=>'8539259',
        'title'=>'Amnistía Internacional Bolivia'},
      {
        'id'=>'8446849',
        'title'=>'Amnistía Internacional Chile'},
      {
        'id'=>'8536054',
        'title'=>'Amnistía Internacional México'},
      {
        'id'=>'8446829',
        'title'=>'Amnistía Internacional Puerto Rico'},
      {
        'id'=>'8446886',
        'title'=>'Amnistía Internacional Uruguay'},
      {
        'id'=>'8539239',
        'title'=>'Amnistía Internacional, Sección Argentina'},
      {
        'id'=>'8513367',
        'title'=>'Amnistía Internacional, Sección Española'},
      {
        'id'=>'8513460',
        'title'=>'Amnistía Internacional, Sección Paraguaya'},
      {
        'id'=>'8602383',
        'title'=>'Andalus Institute for Tolerance and Anti-Violence Studies'},
      {
        'id'=>'8067914',
        'title'=>'Anti Caste Discrimination Alliance'},
      {
        'id'=>'7038757',
        'title'=>'Arab Association for Human Rights'},
      {
        'id'=>'8408203',
        'title'=>'Arab Program for Human Rights Activists'},
      {
        'id'=>'7038783',
        'title'=>'Arabic Network for Human Rights Information'},
      {
        'id'=>'7038525',
        'title'=>'Argentine Forensic Anthropology Team : Equipo Argentino de Antropologia Forense.'},
      {
        'id'=>'6876285',
        'title'=>'Article 19'},
      {
        'id'=>'7038675',
        'title'=>'Asia Pacific Forum : advancing human rights in our region.'},
      {
        'id'=>'7038673',
        'title'=>'Asian Centre for Human Rights : dedicated to promotion and protection of human rights in Asia.'},
      {
        'id'=>'7886427',
        'title'=>'Asian Federation Against Involuntary Disappearances'},
      {
        'id'=>'7038672',
        'title'=>'Asian Forum for Human Rights and Development'},
      {
        'id'=>'7038674',
        'title'=>'Asian Human Rights Commission'},
      {
        'id'=>'7038747',
        'title'=>'Asian Legal Resource Centre'},
      {
        'id'=>'7038448',
        'title'=>'Asociación Pro Derechos Humanos'},
      {
        'id'=>'8287713',
        'title'=>'Asociación por los Derechos Civiles'},
      {
        'id'=>'7038518',
        'title'=>'Assistance Association for Political Prisoners (Burma)'},
      {
        'id'=>'8971608',
        'title'=>'Associação Justiça, Paz e Democracia : Justice, Peace and Democracy Association.'},
      {
        'id'=>'8413637',
        'title'=>'Association for Freedom of Thought and Expression'},
      {
        'id'=>'7038748',
        'title'=>'Association for Women\'s Rights in Development'},
      {
        'id'=>'7038617',
        'title'=>'Association for the Prevention of Torture'},
      {
        'id'=>'7410021',
        'title'=>'Association marocaine des droits humains'},
      {
        'id'=>'7902567',
        'title'=>'Association pour le respect des droits de l\'homme à Djibouti : ARDHD.'},
      {
        'id'=>'7038329',
        'title'=>'Association sahraouie des victimes des violations graves des droits de l\'homme commises par l\'Etat du Maroc'},
      {
        'id'=>'7038786',
        'title'=>'Australian Human Rights Commission'},
      {
        'id'=>'7038742',
        'title'=>'B\'Tselem : The Israeli information center for human rights in the occupied territories.'},
      {
        'id'=>'7038502',
        'title'=>'BAOBAB for Women\'s Human Rights'},
      {
        'id'=>'8438804',
        'title'=>'Baheyya : Egypt analysis and whimsy : commentary on Egyptian politics and culture by an Egyptian citizen with a room of her own.'},
      {
        'id'=>'9170564',
        'title'=>'Basel Action Network : BAN.'},
      {
        'id'=>'7038660',
        'title'=>'Beogradski centar za ljudska prava'},
      {
        'id'=>'7038378',
        'title'=>'Bermuda Ombudsman'},
      {
        'id'=>'7038755',
        'title'=>'Bimkom'},
      {
        'id'=>'9250557',
        'title'=>'British Irish Rights Watch'},
      {
        'id'=>'7813033',
        'title'=>'Burma Lawyers\' Council'},
      {
        'id'=>'7038493',
        'title'=>'CALDH'},
      {
        'id'=>'7813805',
        'title'=>'CELS, Centro de Estudios Legales y Sociales'},
      {
        'id'=>'8618396',
        'title'=>'CONECTAS Direitos Humanos'},
      {
        'id'=>'8460274',
        'title'=>'CRLDHT--Comité pour le respect des libertés et des droits de l\'homme en Tunisie'},
      {
        'id'=>'7923757',
        'title'=>'CSVR : Centre for the Study of Violence and Reconciliation.'},
      {
        'id'=>'8857455',
        'title'=>'Cageprisoners'},
      {
        'id'=>'7410095',
        'title'=>'Cairo Institute for Human Rights Studies'},
      {
        'id'=>'7038586',
        'title'=>'Cambodian League for the Promotion and Defense of Human Rights'},
      {
        'id'=>'7038501',
        'title'=>'Campaign for Good Governance'},
      {
        'id'=>'7038387',
        'title'=>'Canadian Friends of Burma'},
      {
        'id'=>'7799921',
        'title'=>'Center for Economic and Social Rights'},
      {
        'id'=>'7038565',
        'title'=>'Center for Justice and International Law'},
      {
        'id'=>'7819636',
        'title'=>'Center for Social Development : Majhamandal saṃrap Qbhivadhṅ Sangaṃ'},
      {
        'id'=>'7038694',
        'title'=>'Centre for Democratic Development, Research and Training'},
      {
        'id'=>'7038264',
        'title'=>'Centre for Human Rights and Rehabilitation'},
      {
        'id'=>'7038639',
        'title'=>'Centre for Victims of Torture, Nepal'},
      {
        'id'=>'7905284',
        'title'=>'Centre for War Victims and Human Rights'},
      {
        'id'=>'9065250',
        'title'=>'Centre for the Development of People'},
      {
        'id'=>'9050722',
        'title'=>'Centro Nicaragüense de Derechos Humanos'},
      {
        'id'=>'7038492',
        'title'=>'Centro de Derechos Humanos Miguel Agustín Pro Juárez'},
      {
        'id'=>'7038269',
        'title'=>'Centro de Estudios Sociales Padre Juan Montalvo, S.J.'},
      {
        'id'=>'7819664',
        'title'=>'Centro de Justicia para la Paz y el Desarrollo'},
      {
        'id'=>'7834591',
        'title'=>'Child Rights Information & Documentation Centre'},
      {
        'id'=>'7905016',
        'title'=>'Citizenship Rights in Africa Initiative'},
      {
        'id'=>'7876812',
        'title'=>'Coalition for an Effective African Court on Human and Peoples\' Rights'},
      {
        'id'=>'7038732',
        'title'=>'Coalition to Stop the Use of Child Soldiers'},
      {
        'id'=>'7038654',
        'title'=>'Colectivo de Abogados José Alvear Restrepo'},
      {
        'id'=>'7038318',
        'title'=>'Collectif des associations contre l\'impunité au Togo'},
      {
        'id'=>'7038406',
        'title'=>'Comisionado Nacional de los Derechos Humanos'},
      {
        'id'=>'7038464',
        'title'=>'Comisión Andina de Juristas'},
      {
        'id'=>'7038656',
        'title'=>'Comisión Mexicana de Defensa y Promoción de los Derechos Humanos'},
      {
        'id'=>'7038523',
        'title'=>'Comisión Nacional de los Derechos Humanos, México'},
      {
        'id'=>'9079545',
        'title'=>'Comisión de la Verdad y Reconciliación'},
      {
        'id'=>'7813806',
        'title'=>'Comissão de Acolhimento, Verdade, e Reconciliac̦ão de Timor-Leste'},
      {
        'id'=>'7038369',
        'title'=>'Comité Cubano Pro Derechos Humanos'},
      {
        'id'=>'7887220',
        'title'=>'Comité de Familiares de Detenidos-Desaparecidos en Honduras'},
      {
        'id'=>'7815173',
        'title'=>'Comité para la Defensa de los Derechos Humanos en Honduras'},
      {
        'id'=>'7038382',
        'title'=>'Comité sénégalaise des droits de l\'homme'},
      {
        'id'=>'7757146',
        'title'=>'Commissie Gelijke Behandeling'},
      {
        'id'=>'7038413',
        'title'=>'Commission Nationale des Droits de l\'Homme du Togo'},
      {
        'id'=>'7038407',
        'title'=>'Commission for Human Rights and Good Governance'},
      {
        'id'=>'7038262',
        'title'=>'Commission nationale consultative des droits de l\'homme'},
      {
        'id'=>'7732061',
        'title'=>'Commission on Human Rights of the Philippines'},
      {
        'id'=>'7038705',
        'title'=>'Committee to Protect Journalists'},
      {
        'id'=>'7885012',
        'title'=>'Community Appraisal & Motivation Program'},
      {
        'id'=>'9076806',
        'title'=>'Congolese Women\'s Campaign Against Sexual Violence in the Democratic Republic of the Congo (DRC)'},
      {
        'id'=>'7038490',
        'title'=>'Conselho Indigenista Missionário'},
      {
        'id'=>'9217998',
        'title'=>'Control arms'},
      {
        'id'=>'7038652',
        'title'=>'Coordinadora Nacional de Derechos Humanos'},
      {
        'id'=>'7038315',
        'title'=>'Coordinadora de Derechos Humanos del Paraguay'},
      {
        'id'=>'7038491',
        'title'=>'Corporación de Promoción y Defensa de los Derechos del Pueblo'},
      {
        'id'=>'7038447',
        'title'=>'Danish Institute of Human Rights'},
      {
        'id'=>'7038267',
        'title'=>'Darfur Consortium'},
      {
        'id'=>'7038379',
        'title'=>'Defensor del Pueblo de la Nación'},
      {
        'id'=>'7038377',
        'title'=>'Defensor del Pueblo, República de Bolivia'},
      {
        'id'=>'7888758',
        'title'=>'Defensores en linea.com'},
      {
        'id'=>'7038374',
        'title'=>'Defensoría del Pueblo [Peru]'},
      {
        'id'=>'7038403',
        'title'=>'Defensoría del Pueblo de Ecuador'},
      {
        'id'=>'7038375',
        'title'=>'Defensoría del Pueblo de la República de Panamá'},
      {
        'id'=>'7731836',
        'title'=>'Defensoría del Pueblo, República del Paraguay'},
      {
        'id'=>'7038546',
        'title'=>'Democracywatch'},
      {
        'id'=>'7038521',
        'title'=>'Derechos Chile'},
      {
        'id'=>'7038693',
        'title'=>'Deutsches Institut für Menschenrechte'},
      {
        'id'=>'8539924',
        'title'=>'Diethnēs Amnēstia - Hellēniko Tmēma'},
      {
        'id'=>'7757269',
        'title'=>'Diskrimineringsombudsmannen'},
      {
        'id'=>'7038500',
        'title'=>'Ditshwanelo'},
      {
        'id'=>'7038594',
        'title'=>'Down to Earth'},
      {
        'id'=>'7038532',
        'title'=>'ECPAT International'},
      {
        'id'=>'8535465',
        'title'=>'Egyptian Blog for Human Rights'},
      {
        'id'=>'7038790',
        'title'=>'Egyptian Organization for Human Rights'},
      {
        'id'=>'7038248',
        'title'=>'Electoral Institute of Southern Africa'},
      {
        'id'=>'7038545',
        'title'=>'Empowerment and Rights Institute : Ren zhi quan gong zuo shi.'},
      {
        'id'=>'7038811',
        'title'=>'Equality and Human Rights Commission'},
      {
        'id'=>'7905779',
        'title'=>'Eritrean Human Rights Electronic Archive'},
      {
        'id'=>'7038324',
        'title'=>'Ethiopian Human Rights Council'},
      {
        'id'=>'7038443',
        'title'=>'European Roma Rights Center'},
      {
        'id'=>'7815770',
        'title'=>'FOCUS on the Global South'},
      {
        'id'=>'8455464',
        'title'=>'FOHRID--Human Rights and Democratic Forum'},
      {
        'id'=>'7038613',
        'title'=>'Famafrique'},
      {
        'id'=>'8959846',
        'title'=>'Fond za humanitarno pravo'},
      {
        'id'=>'7038606',
        'title'=>'Fond zashchity glasnosti'},
      {
        'id'=>'7033265',
        'title'=>'Forces de libération africaines de Mauritanie'},
      {
        'id'=>'7038249',
        'title'=>'Forum for African Women Educationalists'},
      {
        'id'=>'7038691',
        'title'=>'Foundation for Human Rights Initiative'},
      {
        'id'=>'7038388',
        'title'=>'Friends of Tibet'},
      {
        'id'=>'7038808',
        'title'=>'Front Line'},
      {
        'id'=>'7038313',
        'title'=>'Fundación Centro de Derechos Humanos y Ambiente'},
      {
        'id'=>'7038488',
        'title'=>'Fundación Regional de Asesoría en Derechos Humanos'},
      {
        'id'=>'7038270',
        'title'=>'Fundación Vicaría de la Solidaridad'},
      {
        'id'=>'7820127',
        'title'=>'Fundación de Antropologia Forense de Guatemala : Forensic Anthropology Foundation of Guatemala.'},
      {
        'id'=>'7038489',
        'title'=>'Fundación de Ayuda Social de las Iglesias Cristianas'},
      {
        'id'=>'7038487',
        'title'=>'Gabinete de Assessoria Jurídica as Organizaçoes Populares'},
      {
        'id'=>'7038744',
        'title'=>'Galilee Society'},
      {
        'id'=>'8229614',
        'title'=>'Generación Y'},
      {
        'id'=>'7038689',
        'title'=>'Ghana Center for Democratic Development'},
      {
        'id'=>'7038608',
        'title'=>'Global Alliance against Traffic in Women'},
      {
        'id'=>'7038800',
        'title'=>'Global Witness'},
      {
        'id'=>'7905317',
        'title'=>'Greensboro Truth & Community Reconciliation Project'},
      {
        'id'=>'7837629',
        'title'=>'Greensboro Truth & Reconciliation Commission : seeking truth, working for reconciliation /'},
      {
        'id'=>'7799772',
        'title'=>'HaMoked--Center for the Defence of the Individual'},
      {
        'id'=>'7038562',
        'title'=>'Habitat International Coalition'},
      {
        'id'=>'7038509',
        'title'=>'Hakielimu'},
      {
        'id'=>'7038259',
        'title'=>'Hayastani Hanrapetutʻyan Mardu Irakunkʻneri Pashtpan'},
      {
        'id'=>'7905623',
        'title'=>'Hayʼat al-Inṣāf wa-al-Muṣālaḥah'},
      {
        'id'=>'7038252',
        'title'=>'Hellenic Republic, National Commission for Human Rights'},
      {
        'id'=>'7803400',
        'title'=>'Helsinki Citizens\' Assembly Vanadzor Office'},
      {
        'id'=>'8961341',
        'title'=>'Helsinki Committee for Human Rights in Serbia'},
      {
        'id'=>'7038499',
        'title'=>'Héritiers de la Justice'},
      {
        'id'=>'7732064',
        'title'=>'Human Rights Commission [Zambia]'},
      {
        'id'=>'7038399',
        'title'=>'Human Rights Commission of Malaysia : Suruhanjaya Hak Asasi Manusia Malaysia.'},
      {
        'id'=>'5533057',
        'title'=>'Human Rights Commission of Pakistan'},
      {
        'id'=>'7732067',
        'title'=>'Human Rights Commission of Sri Lanka'},
      {
        'id'=>'7732066',
        'title'=>'Human Rights Commission of the Maldives'},
      {
        'id'=>'7038417',
        'title'=>'Human Rights Commission, New Zealand'},
      {
        'id'=>'7834145',
        'title'=>'Human Rights Concern Eritrea'},
      {
        'id'=>'7038544',
        'title'=>'Human Rights Congress for Bangladesh Minorities'},
      {
        'id'=>'7038644',
        'title'=>'Human Rights Council of Australia'},
      {
        'id'=>'7885006',
        'title'=>'Human Rights Education Institute of Burma'},
      {
        'id'=>'5355337',
        'title'=>'Human Rights First'},
      {
        'id'=>'7890712',
        'title'=>'Human Rights First Society'},
      {
        'id'=>'7038266',
        'title'=>'Human Rights Law Network'},
      {
        'id'=>'8959998',
        'title'=>'Human Rights Press Point'},
      {
        'id'=>'7038429',
        'title'=>'I-India'},
      {
        'id'=>'7038498',
        'title'=>'IDASA'},
      {
        'id'=>'7038527',
        'title'=>'INDICT'},
      {
        'id'=>'7038351',
        'title'=>'Independent Commission for Human Rights'},
      {
        'id'=>'7038653',
        'title'=>'Indeso mujer'},
      {
        'id'=>'7038273',
        'title'=>'Indigenous Peoples Council on Biocolonialism'},
      {
        'id'=>'7038618',
        'title'=>'Indigenous Peoples\' Center for Documentation, Research and Information'},
      {
        'id'=>'9186324',
        'title'=>'Indignación'},
      {
        'id'=>'8964437',
        'title'=>'Informat︠s︡ionno-analiticheskiĭ t︠s︡entr "Sova"'},
      {
        'id'=>'8953012',
        'title'=>'Inimõiguste keskus'},
      {
        'id'=>'7822594',
        'title'=>'Institute for Justice and Reconciliation'},
      {
        'id'=>'8257091',
        'title'=>'Instituto Espacio para la Memoria'},
      {
        'id'=>'9051345',
        'title'=>'Instituto Latinoamericano para una Sociedad y un Derecho Alternativos'},
      {
        'id'=>'9160225',
        'title'=>'Instituto de Defensa Legal - IDL'},
      {
        'id'=>'7038459',
        'title'=>'International Campaign for Tibet'},
      {
        'id'=>'7819711',
        'title'=>'International Coalition for the Responsibility to Protect'},
      {
        'id'=>'5571653',
        'title'=>'International Commission of Jurists'},
      {
        'id'=>'7038540',
        'title'=>'International Commission on Missing Persons'},
      {
        'id'=>'7904970',
        'title'=>'International Committee Against Stoning'},
      {
        'id'=>'7038371',
        'title'=>'International Committee for Democracy in Cuba'},
      {
        'id'=>'7038550',
        'title'=>'International Committee of Solidarity for Political Prisoners in Tunisia'},
      {
        'id'=>'9130439',
        'title'=>'International Criminal Tribunal for Rwanda'},
      {
        'id'=>'5316489',
        'title'=>'International Crisis Group'},
      {
        'id'=>'7038723',
        'title'=>'International Federation of Health and Human Rights Organisations'},
      {
        'id'=>'7890675',
        'title'=>'International Federation of Iranian Refugees'},
      {
        'id'=>'7038815',
        'title'=>'International Gay and Lesbian Human Rights Commission'},
      {
        'id'=>'7038721',
        'title'=>'International League for Human Rights'},
      {
        'id'=>'7038807',
        'title'=>'International Service for Human Rights'},
      {
        'id'=>'7038287',
        'title'=>'International Society for Human Rights'},
      {
        'id'=>'7038537',
        'title'=>'International Work Group for Indigenous Affairs'},
      {
        'id'=>'7038286',
        'title'=>'Invisible Tibet : Woeser\'s blog.'},
      {
        'id'=>'7038648',
        'title'=>'Iran Human Rights Documentation Center'},
      {
        'id'=>'7822959',
        'title'=>'Iran Human Rights Voice'},
      {
        'id'=>'7799940',
        'title'=>'Iraq Foundation'},
      {
        'id'=>'7800011',
        'title'=>'Iraqi Human Rights Group'},
      {
        'id'=>'7038803',
        'title'=>'Islamic Human Rights Commission'},
      {
        'id'=>'8539972',
        'title'=>'Íslandsdeild Amnesty International'},
      {
        'id'=>'7905840',
        'title'=>'İnsan Hakları Ortak Platformu : Human Rights Joint Platform.'},
      {
        'id'=>'7885570',
        'title'=>'Jamʻīyat Shabāb al-Baḥrayn li-Ḥuqūq al-Insān'},
      {
        'id'=>'7038622',
        'title'=>'Jesuit Refugee Service'},
      {
        'id'=>'7819678',
        'title'=>'Jesuit Refugee Service/USA'},
      {
        'id'=>'7038543',
        'title'=>'Judicial System Monitoring Programme'},
      {
        'id'=>'7809241',
        'title'=>'Jumma Peoples Network UK'},
      {
        'id'=>'7038486',
        'title'=>'Justiça Global'},
      {
        'id'=>'9066101',
        'title'=>'Kefayah'},
      {
        'id'=>'7038549',
        'title'=>'Kenya Human Rights Commission'},
      {
        'id'=>'7038494',
        'title'=>'Kenya National Commission on Human Rights'},
      {
        'id'=>'7038683',
        'title'=>'Kgeikani Kweni, First People of the Kalahari'},
      {
        'id'=>'8959905',
        'title'=>'Komitet pravnlka za ljudska prava'},
      {
        'id'=>'7038400',
        'title'=>'Komnas HAM Indonesia'},
      {
        'id'=>'7038604',
        'title'=>'Kosovakosovo.com'},
      {
        'id'=>'7038797',
        'title'=>'Kurdish Human Rights Project'},
      {
        'id'=>'7038462',
        'title'=>'Kurdish Women\'s Rights Watch'},
      {
        'id'=>'7038438',
        'title'=>'Kuru Family of Organisations'},
      {
        'id'=>'7038542',
        'title'=>'Kyrgyz Committee for Human Rights'},
      {
        'id'=>'7038404',
        'title'=>'La Defensoria de los Habitantes'},
      {
        'id'=>'8412117',
        'title'=>'Land Center for Human Rights'},
      {
        'id'=>'7038655',
        'title'=>'Latin American and Caribbean Committee for the Defense of Women\'s Rights'},
      {
        'id'=>'7038657',
        'title'=>'Latvian Centre for Human Rights'},
      {
        'id'=>'7839371',
        'title'=>'Law & Society Trust'},
      {
        'id'=>'7038680',
        'title'=>'Legal and Human Rights Centre'},
      {
        'id'=>'8446737',
        'title'=>'Lembaga Studi dan Advokasi Masyarakat'},
      {
        'id'=>'7890025',
        'title'=>'Ligue algerienne pour la defense des droits de l\'homme'},
      {
        'id'=>'7038685',
        'title'=>'Ligue burundaise des droits de l\'homme'},
      {
        'id'=>'7813807',
        'title'=>'MAP Foundation'},
      {
        'id'=>'7038819',
        'title'=>'Madre'},
      {
        'id'=>'7038412',
        'title'=>'Malawi Human Rights Commission'},
      {
        'id'=>'8459920',
        'title'=>'Malawi Human Rights Resource Centre'},
      {
        'id'=>'8860683',
        'title'=>'Mardu iravunkʻnerě Hayastanum'},
      {
        'id'=>'8414984',
        'title'=>'Markaz Hishām Mubārak lil-Qānūn'},
      {
        'id'=>'7824247',
        'title'=>'Markaz al-Tawthīq wa-al-Iʻlām wa-al-Takwīn fī Majāl Ḥuqūq al-Insān'},
      {
        'id'=>'7038411',
        'title'=>'Mauritius National Human Rights Commission'},
      {
        'id'=>'7890773',
        'title'=>'Mazlumder : İnsan Hakları ve Mazlumlar için Dayanışma Derneği = The Association of Human Rights and Solidarity for Oppressed People.'},
      {
        'id'=>'7033263',
        'title'=>'Media Foundation for West Africa'},
      {
        'id'=>'9085457',
        'title'=>'Memoria Abierta'},
      {
        'id'=>'7038760',
        'title'=>'Mezan Center for Human Rights'},
      {
        'id'=>'7038360',
        'title'=>'Minority Rights Group International'},
      {
        'id'=>'7038398',
        'title'=>'Mongol Ulsyn Khu̇niĭ Ėrkhiĭn U̇ndėsniĭ Komiss'},
      {
        'id'=>'7038669',
        'title'=>'Moskovskai︠a︡ khelʹsinkskai︠a︡ gruppa'},
      {
        'id'=>'7038250',
        'title'=>'Mouvement contre les armes légères en Afrique de l\'Ouest'},
      {
        'id'=>'9051461',
        'title'=>'Movimento Nacional dos Direitos Humanos'},
      {
        'id'=>'7038651',
        'title'=>'Movimento dos Trabalhadores Rurais sem Terra'},
      {
        'id'=>'9094742',
        'title'=>'Munaẓẓamah al-Maghribīyah li-Ḥuqūq al-Insān : Organisation Marocaine des Droits Humains.'},
      {
        'id'=>'8415142',
        'title'=>'Munaẓẓamah al-ʻArabīyah lil-Iṣlāḥ al-Jināʼī'},
      {
        'id'=>'8415370',
        'title'=>'Muʼassasat al-Marʼah al-Jadīdah'},
      {
        'id'=>'8263078',
        'title'=>'NAMRIGHTS'},
      {
        'id'=>'7193114',
        'title'=>'NCHRO : National Confederation of Human Rights Organizations.'},
      {
        'id'=>'7667863',
        'title'=>'NGO Coordination Committee for Iraq : Lajnat Tansīq al-Munaẓẓamāt Ghayr al-Ḥukūmiyah fī al-ʻIrāq.'},
      {
        'id'=>'7038737',
        'title'=>'National Campaign on Dalit Human Rights'},
      {
        'id'=>'7038373',
        'title'=>'National Centre for Human Rights [Jordan]'},
      {
        'id'=>'7038405',
        'title'=>'National Council for Human Rights [Egypt]'},
      {
        'id'=>'7038352',
        'title'=>'National Human Rights Commission of Korea'},
      {
        'id'=>'7038263',
        'title'=>'National Human Rights Commission, Nepal'},
      {
        'id'=>'7038633',
        'title'=>'National Human Rights Commission, New Delhi, India'},
      {
        'id'=>'7038381',
        'title'=>'National Human Rights Commission, Nigeria'},
      {
        'id'=>'7732060',
        'title'=>'National Human Rights Committee : Lajnah al-Waṭanīyah li-Ḥuqūq al-Insān.'},
      {
        'id'=>'9077930',
        'title'=>'National Organization for Defending Rights and Freedoms'},
      {
        'id'=>'8455680',
        'title'=>'National Protection Working Group (NWPG)'},
      {
        'id'=>'8179176',
        'title'=>'National Unity and Reconciliation Commission'},
      {
        'id'=>'7731591',
        'title'=>'Nemzeti és Etnikai Kisebbségi Jogok Országgyűlési Biztosa'},
      {
        'id'=>'7033268',
        'title'=>'Network Movement for Justice and Development'},
      {
        'id'=>'7928882',
        'title'=>'Network of Concerned Historians'},
      {
        'id'=>'7038789',
        'title'=>'New Tactics in Human Rights'},
      {
        'id'=>'7038409',
        'title'=>'Northern Ireland Human Rights Commission'},
      {
        'id'=>'8928169',
        'title'=>'Not On Our Watch'},
      {
        'id'=>'9006551',
        'title'=>'Nuba Survival Foundation'},
      {
        'id'=>'8011158',
        'title'=>'OMAL : Observatorio de Multinacionales en América  Latina.'},
      {
        'id'=>'9085451',
        'title'=>'Observatorio Ciudadano'},
      {
        'id'=>'7038397',
        'title'=>'Office of the National Human Rights Commission of Thailand'},
      {
        'id'=>'7038410',
        'title'=>'Office of the Ombudsman [Namibia]'},
      {
        'id'=>'7731800',
        'title'=>'Office of the Ombudsman of Trinidad and Tobago'},
      {
        'id'=>'7839243',
        'title'=>'Oficina del Procurador del Ciudadano de Puerto Rico'},
      {
        'id'=>'7038255',
        'title'=>'Ombudsman Republike Srpske--zaštitnik ljudskih prava'},
      {
        'id'=>'7038257',
        'title'=>'Ombudsman [Azerbaijan]'},
      {
        'id'=>'7038649',
        'title'=>'One Million Signatures Demanding Changes to Discriminatory Laws'},
      {
        'id'=>'7888713',
        'title'=>'Organización Argentina de Jóvenes para las Naciones Unidas : OAJNU.'},
      {
        'id'=>'7038659',
        'title'=>'Organizat︠s︡ii︠a︡ Drom'},
      {
        'id'=>'7038338',
        'title'=>'Other Russia'},
      {
        'id'=>'9133514',
        'title'=>'PROVEA : Programa Venezolano de Educación-Acción en Derechos Humanos.'},
      {
        'id'=>'7038632',
        'title'=>'Pakistan International Human Rights Organization'},
      {
        'id'=>'7038792',
        'title'=>'Palestinian Center for Human Rights'},
      {
        'id'=>'7960030',
        'title'=>'Paz con Dignidad'},
      {
        'id'=>'7038814',
        'title'=>'Peace Brigades International : making space for peace.'},
      {
        'id'=>'9066303',
        'title'=>'Persian2English'},
      {
        'id'=>'4191511',
        'title'=>'Physicians for Human Rights'},
      {
        'id'=>'9097468',
        'title'=>'Plataforma Interamericana de Derechos Humanos, Democracia y Desarrollo'},
      {
        'id'=>'8409019',
        'title'=>'Point Pedro Institute of Development.'},
      {
        'id'=>'8616290',
        'title'=>'Portail de l\'Organisation TAMAYNUT'},
      {
        'id'=>'7038327',
        'title'=>'Prava li︠u︡dyny v Ukraïni'},
      {
        'id'=>'7038337',
        'title'=>'Pravovai︠a︡ init︠s︡iativa po Rossii'},
      {
        'id'=>'7038820',
        'title'=>'Privacy International'},
      {
        'id'=>'7038402',
        'title'=>'Procuraduria de los Derechos Humanos'},
      {
        'id'=>'7038261',
        'title'=>'Procuraduría para la Defensa de los Derechos Humanos República de Nicaragua--América Central'},
      {
        'id'=>'7038254',
        'title'=>'Pučki pravobranitelj : Ombudsman.'},
      {
        'id'=>'7904717',
        'title'=>'Pukhan minjuhwa net\'ŭwŏk\'ŭ : Network for North Korean Democracy and Human Rights (NKnet).'},
      {
        'id'=>'8930254',
        'title'=>'Qūwat al-ʻAmal li-Munāhaḍat al-Taʻdhīb'},
      {
        'id'=>'7038665',
        'title'=>'RPHA "Belaruski khelʹsinkski kamitėt"'},
      {
        'id'=>'7038793',
        'title'=>'Rabbis for Human Rights'},
      {
        'id'=>'7038710',
        'title'=>'Ramallah Center for Human Rights Studies'},
      {
        'id'=>'9085465',
        'title'=>'Rede Social de Justiça e Direitos Humanos'},
      {
        'id'=>'9065961',
        'title'=>'Regional Watch for Human Rights'},
      {
        'id'=>'7038496',
        'title'=>'Rencontre africaine pour la défense des droits de l\'homme'},
      {
        'id'=>'8961190',
        'title'=>'Republika Makedonija naroden pravobranitel Ombudsman'},
      {
        'id'=>'7033269',
        'title'=>'Réseau des journalistes pour les droits de l\'homme'},
      {
        'id'=>'7038650',
        'title'=>'Réseau national de défense des droits humains--RNDDH'},
      {
        'id'=>'8953033',
        'title'=>'Rrjeti i Grupeve të Grave të Kosovës'},
      {
        'id'=>'7038274',
        'title'=>'Russian Association of Indigenous Peoples of the North, Siberia and the Far East'},
      {
        'id'=>'8960390',
        'title'=>'Satellite Sentinel Project'},
      {
        'id'=>'7038418',
        'title'=>'Sdružení Dženo'},
      {
        'id'=>'8448889',
        'title'=>'Sección Peruana de Amnistía Internacional'},
      {
        'id'=>'7038626',
        'title'=>'Shan Women\'s Action Network'},
      {
        'id'=>'8163119',
        'title'=>'Shirkat Gah : women\'s resource centre.'},
      {
        'id'=>'7813804',
        'title'=>'Sin Fronteras IAP'},
      {
        'id'=>'7033266',
        'title'=>'Sokwanele'},
      {
        'id'=>'7033267',
        'title'=>'Solidarity Peace Trust'},
      {
        'id'=>'8502012',
        'title'=>'South Africa Truth and Reconciliation Commission'},
      {
        'id'=>'7038383',
        'title'=>'South African Human Rights Commission'},
      {
        'id'=>'5533251',
        'title'=>'South Asia Forum for Human Rights'},
      {
        'id'=>'8952643',
        'title'=>'Srebrenica.ba'},
      {
        'id'=>'7038455',
        'title'=>'Students for a Free Tibet'},
      {
        'id'=>'7033270',
        'title'=>'Suara Rakyat Malaysia'},
      {
        'id'=>'7038420',
        'title'=>'Survivor Corps'},
      {
        'id'=>'7038679',
        'title'=>'Tanzania Gender Networking Programme'},
      {
        'id'=>'7038541',
        'title'=>'Tapol'},
      {
        'id'=>'8775601',
        'title'=>'Terra de Direitos : organização  de direitos humanos.'},
      {
        'id'=>'7038784',
        'title'=>'The Advocates for Human Rights'},
      {
        'id'=>'7771968',
        'title'=>'The Association for Civil Rights in Israel'},
      {
        'id'=>'7038386',
        'title'=>'The Burma Campaign UK'},
      {
        'id'=>'7038358',
        'title'=>'The Center for Democracy & Human Rights in Saudi Arabia'},
      {
        'id'=>'7038724',
        'title'=>'The Center for Justice and Accountability'},
      {
        'id'=>'7800014',
        'title'=>'The Committee for the Defense of Human Rights in the Arabian Peninsula'},
      {
        'id'=>'8415331',
        'title'=>'The Egyptian Association for Community Participation Enhancement'},
      {
        'id'=>'8460249',
        'title'=>'The Equal Rights Trust'},
      {
        'id'=>'8408294',
        'title'=>'The Initiative for an Open Arab Internet'},
      {
        'id'=>'7815764',
        'title'=>'The International Network for the Rights of Female Victims of Violence in Pakistan (INRFVVP)'},
      {
        'id'=>'7038681',
        'title'=>'The Lawyers Centre for Legal Assistance'},
      {
        'id'=>'7038780',
        'title'=>'The Palestinian Human Rights Monitoring Group'},
      {
        'id'=>'7901541',
        'title'=>'The Rights Exposure Project'},
      {
        'id'=>'7038467',
        'title'=>'ThinkCentre.org'},
      {
        'id'=>'7038458',
        'title'=>'TibetInfoNet'},
      {
        'id'=>'7038456',
        'title'=>'Tibetan Centre for Human Rights and Democracy'},
      {
        'id'=>'7033264',
        'title'=>'Transition Monitoring Group, Nigeria'},
      {
        'id'=>'4751601',
        'title'=>'Transparency International'},
      {
        'id'=>'8281930',
        'title'=>'Truth and Reconciliation Commission of Liberia'},
      {
        'id'=>'7900280',
        'title'=>'Truth and Reconciliation Commission, Republic of Korea : Chinsil, Hwahae rŭl wihan Kwagŏsa Chŏngni Wiwŏnhoe.'},
      {
        'id'=>'9177497',
        'title'=>'Truth, Justice and Reconciliation Commission of Kenya'},
      {
        'id'=>'7038349',
        'title'=>'Türkiye İnsan Hakları Vakfı'},
      {
        'id'=>'7038439',
        'title'=>'T︠S︡entr informat︠s︡iï ta dokumentat︠s︡iï krymsʹkykh tatar'},
      {
        'id'=>'7971722',
        'title'=>'Uganda Coalition on the International Criminal Court'},
      {
        'id'=>'7732065',
        'title'=>'Uganda Human Rights Commission'},
      {
        'id'=>'8602539',
        'title'=>'Uluslararası Af Örgütü--Türkiye'},
      {
        'id'=>'8966262',
        'title'=>'Unity for Human Rights and Democracy Toronto'},
      {
        'id'=>'7038247',
        'title'=>'University Teachers for Human Rights'},
      {
        'id'=>'7038602',
        'title'=>'Unrepresented Nations and Peoples Organization'},
      {
        'id'=>'7038253',
        'title'=>'Veřejný ochránce práv'},
      {
        'id'=>'8961305',
        'title'=>'Vi︠a︡sna pravaabaronchy tsėntr'},
      {
        'id'=>'7038497',
        'title'=>'Voix des Sans Voix'},
      {
        'id'=>'7038258',
        'title'=>'Volksanwaltschaft'},
      {
        'id'=>'9159182',
        'title'=>'WOREC Nepal'},
      {
        'id'=>'8438858',
        'title'=>'Wa7damasrya'},
      {
        'id'=>'7952274',
        'title'=>'Women Journalists Without Chains : Munaẓẓamat Ṣaḥafīyāt Bilā Quyūd.'},
      {
        'id'=>'5550172',
        'title'=>'Women Living Under Muslim Laws : WLUML = Femmes Sous Lois Musulmanes.'},
      {
        'id'=>'7038451',
        'title'=>'Women for Afghan Women'},
      {
        'id'=>'7038350',
        'title'=>'Women for Women\'s Human Rights'},
      {
        'id'=>'9187439',
        'title'=>'Women\'s Initiatives for Gender Justice'},
      {
        'id'=>'6952107',
        'title'=>'World Organisation Against Torture'},
      {
        'id'=>'7952294',
        'title'=>'Yemeni Human Rights Network'},
      {
        'id'=>'9079995',
        'title'=>'Yemeni Organization for Defending Rights and Democratic Freedom'},
      {
        'id'=>'8379205',
        'title'=>'Yesh Din--volunteers for human rights'},
      {
        'id'=>'7038678',
        'title'=>'Zimbabwe Human Rights NGO Forum'},
      {
        'id'=>'7038677',
        'title'=>'Zimbabwe Lawyers for Human Rights'},
      {
        'id'=>'7038380',
        'title'=>'al-Majlis al-Istishārī li-Ḥuqūq al-Insān : [mawqiʻ intirnit] muʾassasat waṭanīyah lil-nuhūṣ biḥuqūq al-insān wa-ḥimāyatihā = Conseil consultatif des droits de lʹhomme : [site Web] institution nationale pour la protection des driots de lʹhomme.'},
      {
        'id'=>'8408166',
        'title'=>'al-Markaz al-Miṣrī li-Ḥuqūq al-Marʾah : [mawqiʻ intirnit].'},
      {
        'id'=>'8541975',
        'title'=>'al-Marṣad al-Yamanī li-Ḥuqūq al-Insān'},
      {
        'id'=>'8929111',
        'title'=>'al-Waʻy al-Miṣrī'},
      {
        'id'=>'7038805',
        'title'=>'breakthrough'},
      {
        'id'=>'7038466',
        'title'=>'humanrights.ge : web portal on human rights in Georgia = Veb portali adamianis upʻlebebis mesaxeb.'}]
  }}
end