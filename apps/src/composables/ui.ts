export function useCardBackground(color?: string) {
  return {
    background: color ? `linear-gradient(135deg, ${color}DD 0%, ${color}33 100%)` : undefined,
  }
}
