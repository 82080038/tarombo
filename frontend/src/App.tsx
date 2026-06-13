import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import HomePage from './pages/HomePage'
import PersonsPage from './pages/PersonsPage'
import PersonDetailPage from './pages/PersonDetailPage'
import FamilyTreePage from './pages/FamilyTreePage'
import PartuturanPage from './pages/PartuturanPage'
import './App.css'

function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/persons" element={<PersonsPage />} />
        <Route path="/persons/:id" element={<PersonDetailPage />} />
        <Route path="/tree" element={<FamilyTreePage />} />
        <Route path="/partuturan" element={<PartuturanPage />} />
      </Routes>
    </Layout>
  )
}

export default App
