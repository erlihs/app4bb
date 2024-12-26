<template>
  <v-bsb-chart
    bar
    clickable
    :chart-data="chartData1"
    :chart-options="chartOptions1"
    @elementClick="chartClick"
  />
  <v-bsb-chart pie :chart-data="chartData2" :chart-options="chartOptions2" />
</template>

<script setup lang="ts">
const chartData1 = ref({
  datasets: [
    {
      label: 'Bar Dataset -1',
      data: [10, 20, 30, 40],
    },
    {
      label: 'Bar Dataset -2',
      data: [10, 15, 30, 35],
    },
    {
      label: 'Line Dataset',
      data: [10, 30, 10, 20],
      type: 'line',
    },
  ],
  labels: ['January', 'February', 'March', 'April'],
})
const chartOptions1 = ref({
  scales: {
    x: {
      stacked: true,
    },
    y: {
      stacked: true,
    },
  },
})

function chartClick(order: number, index: number, value: number) {
  console.log('Clicked data: ', order, index, value)
  // Do something with the clicked data
}

const chartData2 = ref({
  labels: ['A', 'B', 'C', 'D'],
  datasets: [
    {
      label: 'Pie data',
      type: 'doughnut',
      data: [10, 20, 30, 40],
      backgroundColor: ['#0123456', '#234567', '#345678', '#456789'],
    },
  ],
})

const chartOptions2 = ref({})
</script>
