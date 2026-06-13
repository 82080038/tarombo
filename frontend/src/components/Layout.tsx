import { Link } from 'react-router-dom'
import { TreePine, Users, GitBranch, Calculator } from 'lucide-react'

interface LayoutProps {
  children: React.ReactNode
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-blue-600 text-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <Link to="/" className="flex items-center space-x-2">
              <TreePine className="h-8 w-8" />
              <span className="text-xl font-bold">Tarombo Digital</span>
            </Link>
            
            <nav className="flex space-x-4">
              <Link to="/persons" className="flex items-center space-x-1 px-3 py-2 rounded-md hover:bg-blue-700">
                <Users className="h-4 w-4" />
                <span>Persons</span>
              </Link>
              <Link to="/tree" className="flex items-center space-x-1 px-3 py-2 rounded-md hover:bg-blue-700">
                <GitBranch className="h-4 w-4" />
                <span>Family Tree</span>
              </Link>
              <Link to="/partuturan" className="flex items-center space-x-1 px-3 py-2 rounded-md hover:bg-blue-700">
                <Calculator className="h-4 w-4" />
                <span>Partuturan</span>
              </Link>
            </nav>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {children}
      </main>

      {/* Footer */}
      <footer className="bg-gray-800 text-gray-300 mt-auto">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <p className="text-center">
            © 2026 Tarombo Digital - Marsipature Hutanabe dalam Era Digital
          </p>
        </div>
      </footer>
    </div>
  )
}

export default Layout
