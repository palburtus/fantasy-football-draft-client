import logo from './logo.svg';
import './App.css';
import Home from './components/home';

import { getAnalytics } from "firebase/analytics";

function App() {

  
  return (
    <div className="App">
     <Home/>
    </div>
  );
}

export default App;
