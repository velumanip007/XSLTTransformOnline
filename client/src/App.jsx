import React, { useState } from 'react';
import axios from 'axios';
import { Upload, Trash2, ArrowRightLeft, FileCode, Code, Loader2 } from 'lucide-react';

function App() {
  const [xmlInput, setXmlInput] = useState('');
  const [xsltInput, setXsltInput] = useState('');
  const [output, setOutput] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleFileUpload = (e, setInput) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (event) => {
        setInput(event.target.result);
      };
      reader.readAsText(file);
    }
  };

  const handleTransform = async () => {
    setLoading(true);
    setError(null);
    setOutput('');

    try {
      const response = await axios.post('/api/transform', {
        xml: xmlInput,
        xslt: xsltInput,
      });

      setOutput(response.data.output);
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.error || err.message || 'Transformation failed');
    } finally {
      setLoading(false);
    }
  };

  const clearConsole = () => {
    setOutput('');
    setError(null);
  };

  return (
    <div className="min-h-screen bg-background text-slate-200 p-4 md:p-8 flex flex-col items-center">
      <header className="w-full max-w-7xl mb-8 flex items-center justify-between border-b border-white/10 pb-4">
        <h1 className="text-2xl md:text-3xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent flex items-center gap-2">
          <ArrowRightLeft className="text-blue-400" />
          XSLT Transformer
        </h1>
        <div className="text-sm text-slate-400">Supports XSLT 1.0 & 2.0</div>
      </header>

      <main className="w-full max-w-7xl grid grid-cols-1 md:grid-cols-2 gap-6 mb-8 flex-grow">
        {/* XML Section */}
        <div className="flex flex-col gap-2">
          <div className="flex justify-between items-center mb-1">
            <label className="flex items-center gap-2 font-semibold text-blue-300">
              <FileCode size={18} /> XML Source
            </label>
            <label className="cursor-pointer flex items-center gap-1.5 text-xs bg-slate-800 hover:bg-slate-700 px-3 py-1.5 rounded-full transition-colors border border-white/10">
              <Upload size={14} />
              Browse File
              <input type="file" accept=".xml" className="hidden" onChange={(e) => handleFileUpload(e, setXmlInput)} />
            </label>
          </div>
          <textarea
            className="flex-grow w-full h-[600px] bg-surface border border-white/10 rounded-lg p-4 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/50 transition-all resize-none shadow-inner"
            placeholder="Paste your XML here..."
            value={xmlInput}
            onChange={(e) => setXmlInput(e.target.value)}
          />
        </div>

        {/* XSLT Section */}
        <div className="flex flex-col gap-2">
          <div className="flex justify-between items-center mb-1">
            <label className="flex items-center gap-2 font-semibold text-purple-300">
              <Code size={18} /> XSLT Stylesheet
            </label>
            <label className="cursor-pointer flex items-center gap-1.5 text-xs bg-slate-800 hover:bg-slate-700 px-3 py-1.5 rounded-full transition-colors border border-white/10">
              <Upload size={14} />
              Browse File
              <input type="file" accept=".xsl,.xslt" className="hidden" onChange={(e) => handleFileUpload(e, setXsltInput)} />
            </label>
          </div>
          <textarea
            className="flex-grow w-full h-[600px] bg-surface border border-white/10 rounded-lg p-4 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-purple-500/50 transition-all resize-none shadow-inner"
            placeholder="Paste your XSLT here..."
            value={xsltInput}
            onChange={(e) => setXsltInput(e.target.value)}
          />
        </div>
      </main>

      {/* Action Bar */}
      <div className="w-full max-w-7xl flex justify-center gap-4 mb-8">
        <button
          onClick={handleTransform}
          disabled={loading || !xmlInput || !xsltInput}
          className="bg-blue-600 hover:bg-blue-500 disabled:opacity-50 disabled:cursor-not-allowed text-white px-8 py-3 rounded-xl font-bold text-lg shadow-lg shadow-blue-500/20 transition-all transform hover:scale-105 active:scale-95 flex items-center gap-2"
        >
          {loading ? <Loader2 className="animate-spin" /> : 'Transform'}
        </button>

        <button
          onClick={clearConsole}
          className="bg-transparent border border-slate-600 text-slate-300 hover:bg-slate-800 px-6 py-3 rounded-xl font-medium transition-all flex items-center gap-2"
        >
          <Trash2 size={18} /> Clear Output
        </button>
      </div>

      {/* Output Console */}
      <div className="w-full max-w-7xl h-[600px] flex flex-col bg-black/50 rounded-xl border border-white/10 overflow-hidden shadow-2xl">
        <div className="bg-slate-900/80 p-3 border-b border-white/5 flex justify-between items-center backdrop-blur-sm">
          <span className="font-mono text-sm font-semibold text-emerald-400 flex items-center gap-2">
            Console Output
          </span>
          {error && <span className="text-red-400 text-xs font-mono">Process terminated with errors</span>}
          {!error && output && <span className="text-green-400 text-xs font-mono">Success</span>}
        </div>
        <div className="flex-grow overflow-auto p-4 custom-scrollbar">
          {loading && (
            <div className="flex items-center justify-center h-full text-slate-500 animate-pulse gap-2">
              <Loader2 className="animate-spin" /> Processing transformation...
            </div>
          )}
          {error ? (
            <pre className="text-red-400 font-mono text-sm whitespace-pre-wrap">{error}</pre>
          ) : (
            <pre className="text-slate-300 font-mono text-sm whitespace-pre-wrap">{output || <span className="text-slate-600 italic">Waiting for input...</span>}</pre>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
