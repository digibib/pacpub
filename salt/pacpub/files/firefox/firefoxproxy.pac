function FindProxyForURL (url, host) {
  if (host=='wiki.deichman.no' || host == 'rom.deichman.no') {
    return 'PROXY 171.23.133.209';
  }
  // or leave as is
  return 'DIRECT';
}