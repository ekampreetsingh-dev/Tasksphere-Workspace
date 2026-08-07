const CACHE_NAME = 'tasksphere-cache-v1';
const urlsToCache = [
  './index.html',
  './manifest.json'
];

// Install the service worker and cache files
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

// Serve cached files when offline
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Return cached file if found, otherwise fetch from internet
        return response || fetch(event.request);
      })
  );
});
