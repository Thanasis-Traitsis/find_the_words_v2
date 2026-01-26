enum CustomIcons {
  // Arrows
  arrowDown('arrow_down'),
  arrowLeft('arrow_left'),
  arrowRight('arrow_right'),
  arrowsUpDown('arrows_up_down'),

  // Snackbar
  warning('warning'),
  error('error'),

  // UI Elements
  box('box'),
  check('check'),
  close('close'),
  filter('filter'),
  flag('flag'),
  gift('gift'),
  help('help'),
  info('info'),
  list('list'),
  logo('logo'),
  magicWand('magic_wand'),
  questionmark('questionmark'),
  reset('reset'),
  rules('rules'),
  settings('settings'),
  shuffle('shuffle'),
  star('star'),
  stars('stars'),
  target('target'),
  tips('tips'),
  webLink('web_link'),
  store('store'),
  watchAd('watch_ad'),
  discount('discount'),
  time('time'),
  stage('stage'),
  freeze('freeze'),
  expand('expand'),
  logout('logout'),
  avatar('avatar'),
  noWifi('no_wifi'),
  levelUp('level_up'),
  crossword('crossword'),

  // Logos
  homeLogoEn('home_logo_en'),
  homeLogo('home_logo'),

  // Social
  google('google');

  const CustomIcons(this.fileName);
  
  final String fileName;
}
