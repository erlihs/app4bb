<template>
  <Bar
    ref="chartRef"
    v-if="bar"
    :data="chartDataBar"
    :options="chartOptions"
    :plugins="chartPlugins"
    :clickable
    @click="onChartClick"
  />
  <Line
    ref="chartRef"
    v-else-if="line"
    :data="chartDataLine"
    :options="chartOptions"
    :plugins="chartPlugins"
    @click="onChartClick"
  />
  <Pie
    ref="chartRef"
    v-else-if="pie"
    :data="chartDataPie"
    :options="chartOptions"
    :plugins="chartPlugins"
    @click="onChartClick"
  />
  <Doughnut
    ref="chartRef"
    v-else-if="doughnut"
    :data="chartDataDoughnut"
    :options="chartOptions"
    :plugins="chartPlugins"
    @click="onChartClick"
  />
  <Radar
    ref="chartRef"
    v-else-if="radar"
    :data="chartDataRadar"
    :options="chartOptions"
    :plugins="chartPlugins"
    @click="onChartClick"
  />
  <PolarArea
    ref="chartRef"
    v-else-if="polarArea"
    :data="chartDataPolarArea"
    :options="chartOptions"
    :plugins="chartPlugins"
    @click="onChartClick"
  />
  <Scatter
    ref="chartRef"
    v-else-if="scatter"
    :data="chartDataScatter"
    :options="chartOptions"
    :plugins="chartPlugins"
    @click="onChartClick"
  />
</template>

<script setup lang="ts">
import { Bar, Line, Pie, Doughnut, Radar, PolarArea, Scatter } from 'vue-chartjs'
import type { ChartData, ChartEvent } from 'chart.js'
import {
  Chart,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  LineElement,
  PointElement,
  ArcElement,
  RadialLinearScale,
  Filler,
  ScatterController,
  type ActiveElement,
} from 'chart.js'
import autocolors from 'chartjs-plugin-autocolors'

Chart.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  LineElement,
  PointElement,
  ArcElement,
  RadialLinearScale,
  Filler,
  ScatterController,
  autocolors,
)

const props = defineProps({
  bar: { type: Boolean, default: false },
  line: { type: Boolean, default: false },
  pie: { type: Boolean, default: false },
  doughnut: { type: Boolean, default: false },
  radar: { type: Boolean, default: false },
  polarArea: { type: Boolean, default: false },
  scatter: { type: Boolean, default: false },
  clickable: { type: Boolean, default: false },
  chartData: {
    type: Object as PropType<
      ChartData<'bar' | 'line' | 'pie' | 'doughnut' | 'radar' | 'polarArea' | 'scatter'>
    >,
    required: true,
    validator: (
      value: ChartData<'bar' | 'line' | 'pie' | 'doughnut' | 'radar' | 'polarArea' | 'scatter'>,
    ) => Array.isArray(value.datasets),
  },
  chartOptions: { type: Object, default: () => ({}) },
  chartPlugins: [],
})

const defaultChartOptions = {
  onHover: (event: ChartEvent, chartElement: ActiveElement[], chart: Chart) => {
    if (props.clickable) {
      chart.canvas.style.cursor = chartElement.length > 0 ? 'pointer' : 'default'
    }
    if (event.native) {
      event.native.preventDefault()
    }
  },
}

function mergeOptions(defaults: object, options: object): object {
  return { ...defaults, ...options }
}

const chartOptions = computed(() => {
  return mergeOptions(defaultChartOptions, props.chartOptions)
})

const emit = defineEmits(['elementClick'])

const chartRef = ref<InstanceType<
  | typeof Bar
  | typeof Line
  | typeof Pie
  | typeof Doughnut
  | typeof Radar
  | typeof PolarArea
  | typeof Scatter
> | null>(null)

const chartDataBar = computed(() =>
  props.bar ? (props.chartData as ChartData<'bar'>) : { datasets: [] },
)
const chartDataLine = computed(() =>
  props.line ? (props.chartData as ChartData<'line'>) : { datasets: [] },
)
const chartDataPie = computed(() =>
  props.pie ? (props.chartData as ChartData<'pie'>) : { datasets: [] },
)
const chartDataDoughnut = computed(() =>
  props.doughnut ? (props.chartData as ChartData<'doughnut'>) : { datasets: [] },
)
const chartDataRadar = computed(() =>
  props.radar ? (props.chartData as ChartData<'radar'>) : { datasets: [] },
)
const chartDataPolarArea = computed(() =>
  props.polarArea ? (props.chartData as ChartData<'polarArea'>) : { datasets: [] },
)
const chartDataScatter = computed(() =>
  props.scatter ? (props.chartData as ChartData<'scatter'>) : { datasets: [] },
)

function onChartClick(event: MouseEvent) {
  if (!props.clickable) return

  const chartInstance = chartRef.value?.chart as unknown as Chart
  if (!chartInstance) return

  const elements = chartInstance.getElementsAtEventForMode(
    event,
    'nearest',
    { intersect: true },
    false,
  )

  if (elements.length) {
    const firstElement: ActiveElement = elements[0]
    const datasetIndex = firstElement.datasetIndex
    const dataIndex = firstElement.index

    const dataset = chartInstance.data.datasets[datasetIndex]
    const clickedData = dataset.data[dataIndex]

    const order = datasetIndex
    const index = dataIndex
    const value = clickedData

    emit('elementClick', order, index, value)
  }
}
</script>
