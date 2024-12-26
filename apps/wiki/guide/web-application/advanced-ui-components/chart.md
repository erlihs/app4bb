# Chart

**Chart** component is based on [ChartJs](https://vue-chartjs.org/) and named `v-bsb-chart`. Implementation differs with:

- instead of `<Bar ...` use `<v-bsb-chart bar ...>`
- `clickable` property that changes mouse cursor to _pointer_ when moving over visible data areas
- emit `elementClick` that returns dataset index, data index and data value on mouse click

## Setup

1. Install

```ps
npm i vue-chartjs chart.js
npm i --save chartjs-plugin-autocolors
```

2. Create component wrapper

::: details `@/components/VBsbChart.vue`
<<< @../../src/components/VBsbChart.vue
:::

3. Create component test

::: details `@/components/__tests__/VBsbChart.test.ts`

<!-- prettier-ignore -->
<<< @../../src/components/__tests__/VBsbChart.test.ts
:::

## Usage

Some examples:

::: code-group

```vue [Bar (clickable)]
<template>
  <v-card>
    <v-card-title>Chart</v-card-title>
    <v-bsb-chart
      bar
      clickable
      :chart-data="chartData1"
      :chart-options="chartOptions1"
      @elementClick="chartClick"
    />
  </v-card>
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
</script>
```

```vue [Pie]
<template>
  <v-card>
    <v-card-title>Chart</v-card-title>
    <v-bsb-chart pie :chart-data="chartData2" :chart-options="chartOptions2" />
  </v-card>
</template>

<script setup lang="ts">
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
```

:::

## API

| Property  | Type    | Description                                              | Default |
| --------- | ------- | -------------------------------------------------------- | ------- |
| bar       | Boolean | Chart type `Bar`                                         | false   |
| line      | Boolean | Chart type `Line`                                        | false   |
| pie       | Boolean | Chart type `Pie`                                         | false   |
| doughnut  | Boolean | Chart type `Doughnut`                                    | false   |
| radar     | Boolean | Chart type `Radar`                                       | false   |
| polarArea | Boolean | Chart type `PolarArea`                                   | false   |
| bubble    | Boolean | Chart type `Bubble`                                      | false   |
| scatter   | Boolean | Chart type `Scatter`                                     | false   |
| clickable | Boolean | Changes cursor to pointer and allows emit `elementClick` | false   |

| Emits        | Description                                                     |
| ------------ | --------------------------------------------------------------- |
| elementClick | Returns dataset index, data index and data value on mouse click |

Check all other [configuration options](https://www.chartjs.org/docs/latest/configuration/) of **ChartJS**
