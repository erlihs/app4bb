<template>
  <v-container>
    <v-row height="200px">
      <v-col>
        <v-bsb-map
          ref="map"
          :zoom
          :center
          :markers
          @marked="markersChanged"
          @centered="centerChanged"
          @zoomed="zoomChanged"
          @located="locationChanged"
          @loading="loadingChanged"
          @clicked="clickChanged"
        />
      </v-col>
      <v-col>
        {{ zoom }}
        <br />
        <v-btn @click="zoom++">Zoom in</v-btn>
        <v-btn @click="zoom--">Zoom out</v-btn>
        <hr class="mt-4 mb-4" />
        {{ location }}
        <br />
        <v-btn @click="center = { lat: 0, lng: 0 }">Center</v-btn>
        <v-btn @click="center = { lat: map?.location.lat, lng: map?.location.lng }">Current</v-btn>
        <v-btn @click="center = { lat: 40.7128, lng: -74.006 }">New York</v-btn>
        <v-btn @click="center = { lat: 34.0522, lng: -118.2437 }">Los Angeles</v-btn>
        <hr class="mt-4 mb-4" />
        <v-btn
          @click="
            map?.setMarkers([
              { lat: 34.0522, lng: -118.2437, title: 'Los Angeles', color: 'purple' },
            ])
          "
          >Add marker</v-btn
        >
        <v-btn @click="map?.delMarkers([{ lat: 34.0522, lng: -118.2437 }])">Remove marker</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
definePage({ meta: { role: 'restricted' } })
import VBsbMap, { type TBsbMapMarker } from '@/components/VBsbMap.vue'
const map = ref<typeof VBsbMap | null>(null)

const center = ref({ lat: 34.0522, lng: -118.2437 })

const location = computed(() => `lat: ${center.value.lat}, lng: ${center.value.lng}`)

const zoom = ref(10)

const markers = ref<TBsbMapMarker[]>([
  {
    lat: 40.689253,
    lng: -74.046689,
    title: 'Statue of Liberty',
    color: 'blue',
    info: 'The <strong>Statue of Liberty</strong> is a colossal neoclassical sculpture on Liberty Island in New York Harbor in New York City, in the United States.',
  },
  { lat: 40.748817, lng: -73.985428, title: 'Empire State Building', color: 'red' },
  { lat: 40.712776, lng: -74.005974, title: 'One World Trade Center', color: 'green' },
])

function centerChanged(newCenter: { lat: number; lng: number }) {
  console.log('centerChanged', newCenter)
}

function zoomChanged(newZoom: number) {
  console.log('zoomChanged', newZoom)
  zoom.value = newZoom
}

function locationChanged(newLocation: { lat: number; lng: number }) {
  console.log('locationChanged', newLocation)
}

function markersChanged(newMarkers: TBsbMapMarker[]) {
  console.log('markersChanged', newMarkers)
}

function loadingChanged(newLoading: boolean) {
  console.log('loadingChanged', newLoading)
}

function clickChanged(newLocation: { lat: number; lng: number }) {
  console.log('clickChanged', newLocation)
}
</script>
