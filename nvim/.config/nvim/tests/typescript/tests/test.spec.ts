import { describe, expect, it } from 'vitest'

import { truthy } from '../src/truthy'


describe('suite', () => {
  it('is truthy', () => {
    expect(truthy()).toBeTruthy()
  })

  it('is false', () => {
    expect(!truthy()).toBeFalsy()
  })
})
