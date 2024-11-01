import { useState } from 'react'
import Radial from './component/radial'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <Radial/>
    </>
  )
}

export default App
