enum EventType { open, launch }

enum InterType {
  topic,
  article,
  // Region without ads
  none,
}

enum AppOpenType {
  start,
  apps,
}

enum AdEvent {
  load,
  loaded,
  open,
  close,
  click,
  failedLoad,
  failedShow,
  impression,
}

enum AdType {
  appOpen,
  nativeBanner,
  interstitial,
  rewarded,
}

enum SubEvent {
  startBuy,
  successBuy,
  failedBuy,
  startRestore,
  failedRestore,
  successRestore,
}
