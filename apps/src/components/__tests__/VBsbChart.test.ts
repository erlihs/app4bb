import { mount } from '@vue/test-utils'
import { describe, it, expect, vi } from 'vitest'
import ChartComponent from '@/components/VBsbChart.vue'
import { Bar, Line, Pie, Doughnut, Radar, PolarArea, Scatter } from 'vue-chartjs'
import type { ChartData, Chart, ChartEvent } from 'chart.js'

describe('ChartComponent', () => {
  const chartData: ChartData<'bar'> = {
    labels: ['January', 'February', 'March'],
    datasets: [
      {
        label: 'Dataset 1',
        data: [10, 20, 30],
      },
    ],
  }

  const chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        display: true,
      },
    },
  }

  it('renders Bar chart when bar prop is true', () => {
    const wrapper = mount(ChartComponent, {
      props: {
        bar: true,
        chartData,
        chartOptions,
      },
    })
    expect(wrapper.findComponent(Bar).exists()).toBe(true)
  })

  it('renders Line chart when line prop is true', () => {
    const wrapper = mount(ChartComponent, {
      props: {
        line: true,
        chartData,
        chartOptions,
      },
    })
    expect(wrapper.findComponent(Line).exists()).toBe(true)
  })

  it('renders Pie chart when pie prop is true', () => {
    const wrapper = mount(ChartComponent, {
      props: {
        pie: true,
        chartData,
        chartOptions,
      },
    })
    expect(wrapper.findComponent(Pie).exists()).toBe(true)
  })

  it('renders Doughnut chart when doughnut prop is true', () => {
    const wrapper = mount(ChartComponent, {
      props: {
        doughnut: true,
        chartData,
        chartOptions,
      },
    })
    expect(wrapper.findComponent(Doughnut).exists()).toBe(true)
  })

  it('renders Radar chart when radar prop is true', () => {
    const wrapper = mount(ChartComponent, {
      props: {
        radar: true,
        chartData,
        chartOptions,
      },
    })
    expect(wrapper.findComponent(Radar).exists()).toBe(true)
  })

  it('renders PolarArea chart when polarArea prop is true', () => {
    const wrapper = mount(ChartComponent, {
      props: {
        polarArea: true,
        chartData,
        chartOptions,
      },
    })
    expect(wrapper.findComponent(PolarArea).exists()).toBe(true)
  })

  it('renders Scatter chart when scatter prop is true', () => {
    const wrapper = mount(ChartComponent, {
      props: {
        scatter: true,
        chartData,
        chartOptions,
      },
    })
    expect(wrapper.findComponent(Scatter).exists()).toBe(true)
  })

  it('emits elementClick event when chart element is clicked', async () => {
    const wrapper = mount(ChartComponent, {
      props: {
        bar: true,
        clickable: true,
        chartData,
        chartOptions,
      },
    })

    const mockChart = vi.fn() as unknown as Chart
    mockChart.getElementsAtEventForMode = vi.fn().mockReturnValue([{ datasetIndex: 0, index: 1 }])
    mockChart.data = {
      datasets: [{ data: [10, 20, 30] }],
    } as ChartData<'bar'>

    // Access chart ref after component is mounted
    const chartRef = wrapper.vm.$refs.chartRef as unknown
    if (chartRef && typeof chartRef === 'object' && 'chart' in chartRef) {
      ;(chartRef as { chart: Chart }).chart = mockChart
    }

    const mockEvent = {
      native: new MouseEvent('click'),
      type: 'click',
      x: 100,
      y: 100,
    } as unknown as ChartEvent

    // Cast to unknown first then to the expected type
    const component = wrapper.vm as unknown as { onChartClick: (event: ChartEvent) => void }
    component.onChartClick(mockEvent as ChartEvent)

    expect(wrapper.emitted().elementClick).toBeTruthy()
    expect(wrapper.emitted().elementClick[0]).toEqual([0, 1, 20])
  })
})
