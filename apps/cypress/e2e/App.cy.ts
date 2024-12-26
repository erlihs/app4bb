describe('Open app', () => {
  it('visits the app root url', () => {
    cy.visit('http://localhost:5173/')
    cy.contains('h1', 'Home')
  })
})

describe('Navigate to About', () => {
  it('visits the about page', () => {
    cy.visit('http://localhost:5173/about')
    cy.contains('h1', 'About')
  })
})