"use client";
import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);

  const getCount = () => {
    alert(`Current Count: ${count}`);
  };

  return (
    <div className="min-h-screen bg-blue -100">
      {/* Header */}
      <header className="flex justify-between items-center p-4 bg-white shadow-md">
        <h1 className="text-2xl font-bold">JB-Counter</h1>
        <button className="px-4 py-2 bg-black -500 text-white rounded-lg">
          Connect Wallet
        </button>
      </header>

      {/* Counter Section */}
      <div className="flex flex-col items-center justify-center mt-20">
        <div className="p-6 bg-white shadow-lg rounded-lg text-center">
          <h1 className="text-4xl font-bold mb-4">{count}</h1>
          <div className="space-x-3">
            <button 
              onClick={() => setCount(count + 1)} 
              className="px-4 py-2 bg-green-500 text-white rounded-lg"
            >
              Increase
            </button>
            <button 
              onClick={() => setCount(count - 1)} 
              className="px-4 py-2 bg-red-500 text-white rounded-lg"
            >
              Decrease
            </button>
            <button 
              onClick={() => setCount(0)} 
              className="px-4 py-2 bg-gray-500 text-white rounded-lg"
            >
              Reset
            </button>
            <button 
              onClick={getCount} 
              className="px-4 py-2 bg-blue-500 text-white rounded-lg"
            >
              Get Count
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
