import type { ComponentPublicInstance } from 'vue'

type StackTraceElement = {
  functionName: string | null
  fileName: string | null
  lineNumber: number | null
  columnNumber: number | null
}

function parseStackTrace(stack: string): StackTraceElement[] {
  const stackLines = stack.split('\n')
  const stackTrace: StackTraceElement[] = []

  const chromeFirefoxRegex = /at\s+(.*?)\s+\(?(.+?):(\d+):(\d+)\)?/
  const edgeRegex = /^\s*([^\s]+)@(.+?):(\d+):(\d+)$/
  const safariRegex = /(\w+@\S+):(\d+):(\d+)/

  for (const line of stackLines) {
    let match

    if ((match = line.match(chromeFirefoxRegex))) {
      const functionName = match[1] !== 'anonymous' ? match[1] : null
      const fileName = match[2]
      const lineNumber = parseInt(match[3], 10)
      const columnNumber = parseInt(match[4], 10)

      stackTrace.push({ functionName, fileName, lineNumber, columnNumber })
    } else if ((match = line.match(edgeRegex))) {
      const functionName = match[1] !== 'anonymous' ? match[1] : null
      const fileName = match[2]
      const lineNumber = parseInt(match[3], 10)
      const columnNumber = parseInt(match[4], 10)

      stackTrace.push({ functionName, fileName, lineNumber, columnNumber })
    } else if ((match = line.match(safariRegex))) {
      const functionName = null
      const fileName = match[1]
      const lineNumber = parseInt(match[2], 10)
      const columnNumber = parseInt(match[3], 10)

      stackTrace.push({ functionName, fileName, lineNumber, columnNumber })
    }
  }

  return stackTrace
}

export const errorHandler = function (
  err: unknown,
  instance: ComponentPublicInstance | null,
  info: string,
) {
  if (import.meta.env.MODE !== 'production') console.error(err, instance, info)

  let errorMessage = ''
  let stackTrace = [] as StackTraceElement[]

  if (err instanceof Error) {
    errorMessage = err.message
    if (err.stack) {
      stackTrace = parseStackTrace(err.stack)
    }
  } else if (typeof err === 'string') {
    errorMessage = err
  } else {
    errorMessage = JSON.stringify(err)
  }

  const instanceName = instance?.$options.name || 'unknown component'
  const instanceProps = instance?.$props || {}

  let errorDetails = ''
  try {
    errorDetails = JSON.stringify(
      {
        error: errorMessage,
        instance: {
          name: instanceName,
          props: instanceProps,
        },
        info: info,
        stackTrace: stackTrace,
      },
      null,
      '\t',
    )
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error'
    errorDetails = `Failed to stringify error details: ${errorMessage}`
  }

  const auditStore = useAuditStore()
  auditStore.err(errorMessage, errorDetails)
}
