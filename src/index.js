import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { BrowserRouter } from "react-router-dom";
import { MoralisProvider } from "react-moralis";
import { NotificationProvider } from 'web3uikit';



ReactDOM.render(
  <React.StrictMode>
    <MoralisProvider appId="AHlLfT6ETHzylcGF4NN3dv0vRM1DyJtz3e2BwbZs" serverUrl="https://4ntvszctfq6v.usemoralis.com:2053/server">
      <NotificationProvider>
      <BrowserRouter>
        <App />
      </BrowserRouter>
      </NotificationProvider>
    </MoralisProvider>
  </React.StrictMode>,
  document.getElementById('root')
);

reportWebVitals();
