export function useCardBackground(color?: string) {
  const theme  = useTheme()
  return (!theme.current.value.dark) ? {
    background: color ? `linear-gradient(135deg, ${color}DD 0%, ${color}77 100%)` : undefined
  }
    :{
    background: color ? `linear-gradient(135deg, ${color}66 0%, ${color}11 100%)` : undefined
  }
}
