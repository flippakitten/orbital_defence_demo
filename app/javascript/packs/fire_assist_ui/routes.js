import React from 'react'
import {
  BrowserRouter as Router,
  Route,
} from 'react-router-dom'

import Container from './components/Container.js'

const App = (props) => (
  <Router>
  <div>
      <Route exact path='/' component={Container} />
    </div>
  </Router>

)

export default App;