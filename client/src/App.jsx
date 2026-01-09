import React, { useState, useRef } from 'react';
import axios from 'axios';
import { Upload, Trash2, ArrowRightLeft, FileCode, Code, Loader2 } from 'lucide-react';

// Configure Axios base URL
axios.defaults.baseURL = 'http://localhost:3000';

function App() {
  const [xmlInput, setXmlInput] = useState('');
  const [xsltInput, setXsltInput] = useState('');
  const [xsdInput, setXsdInput] = useState('');
  const [output, setOutput] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [mode, setMode] = useState('transform'); // 'transform' | 'validate'

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
    if (!xmlInput || !xsltInput) {
      setError('Please provide both XML and XSLT content.');
      return;
    }

    setLoading(true);
    setError('');
    setOutput('');

    try {
      // Hybrid Approach: 
      // 1. Compile XSLT on Server -> SEF
      // 2. Transform on Client (Browser)

      console.log("Step 1: Requesting XSLT Compilation from Server...");
      const compileResponse = await axios.post('/api/compile', {
        xslt: xsltInput
      });

      const sef = compileResponse.data.sef;
      console.log("Step 1 Complete. SEF Received.");

      console.log("Step 2: Transforming locally in Browser using SaxonJS...");

      // Transform using SaxonJS
      // We use "async" execution to avoid freezing the UI for massive transforms
      const result = await window.SaxonJS.transform({
        stylesheetInternal: sef,
        sourceText: xmlInput,
        destination: "serialized"
      }, "async");

      console.log("Step 2 Complete. Transformation Success.");

      setOutput(result.principalResult);

    } catch (err) {
      console.error("Transformation Error:", err);
      const errorMsg = err.response?.data?.error || err.message || "An error occurred during transformation.";
      setError(`Transformation Failed: ${errorMsg}`);
    } finally {
      setLoading(false);
    }
  };

  const handleValidate = async () => {
    setLoading(true);
    setError(null);
    setOutput('');

    try {
      const response = await axios.post('/api/validate', {
        xml: xmlInput,
        xsd: xsdInput,
      });

      const { valid, errors } = response.data;
      if (valid) {
        setOutput('✅ XML is VALID against the XSD Schema.');
      } else {
        const errorMsg = ['❌ XML is INVALID:', ...errors].join('\n');
        setOutput(errorMsg);
        // Also set error state to show red color in header if desired, 
        // but output area handles it well. 
        // Let's set error state for consistency if we want red text.
        // setError('Validation Failed'); // removed to show details
        setOutput(errorMsg); // Override output to show details
      }
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.error || err.message || 'Validation request failed');
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
      <header className="w-full max-w-7xl mb-8 flex flex-col items-center gap-4 border-b border-white/10 pb-4">
        <div className="w-full flex items-center justify-between">
          <h1 className="text-2xl md:text-3xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent flex items-center gap-2">
            <ArrowRightLeft className="text-blue-400" />
            XSLT Transformer
          </h1>
          <div className="text-sm text-slate-400">Supports XSLT 1.0 & 2.0 + XSD</div>
        </div>

        {/* Mode Switcher */}
        <div className="flex bg-slate-900 p-1 rounded-lg border border-white/10">
          <button
            onClick={() => setMode('transform')}
            className={`px-6 py-2 rounded-md font-medium text-sm transition-all ${mode === 'transform' ? 'bg-blue-600 text-white shadow-lg' : 'text-slate-400 hover:text-white'}`}
          >
            Transformation
          </button>
          <button
            onClick={() => setMode('validate')}
            className={`px-6 py-2 rounded-md font-medium text-sm transition-all ${mode === 'validate' ? 'bg-emerald-600 text-white shadow-lg' : 'text-slate-400 hover:text-white'}`}
          >
            Validator
          </button>
        </div>
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

        {/* Right Section (XSLT or XSD) */}
        {mode === 'transform' ? (
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
        ) : (
          <div className="flex flex-col gap-2">
            <div className="flex justify-between items-center mb-1">
              <label className="flex items-center gap-2 font-semibold text-emerald-300">
                <FileCode size={18} /> XSD Schema
              </label>
              <label className="cursor-pointer flex items-center gap-1.5 text-xs bg-slate-800 hover:bg-slate-700 px-3 py-1.5 rounded-full transition-colors border border-white/10">
                <Upload size={14} />
                Browse File
                <input type="file" accept=".xsd" className="hidden" onChange={(e) => handleFileUpload(e, setXsdInput)} />
              </label>
            </div>
            <textarea
              className="flex-grow w-full h-[600px] bg-surface border border-white/10 rounded-lg p-4 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/50 transition-all resize-none shadow-inner"
              placeholder="Paste your XSD Schema here..."
              value={xsdInput}
              onChange={(e) => setXsdInput(e.target.value)}
            />
          </div>
        )}
      </main>

      {/* Action Bar */}
      <div className="w-full max-w-7xl flex justify-center gap-4 mb-8">
        <button
          onClick={mode === 'transform' ? handleTransform : handleValidate}
          disabled={loading || !xmlInput || (mode === 'transform' ? !xsltInput : !xsdInput)}
          className={`px-8 py-3 rounded-xl font-bold text-lg shadow-lg transition-all transform hover:scale-105 active:scale-95 flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed ${mode === 'transform' ? 'bg-blue-600 hover:bg-blue-500 shadow-blue-500/20 text-white' : 'bg-emerald-600 hover:bg-emerald-500 shadow-emerald-500/20 text-white'}`}
        >
          {loading ? <Loader2 className="animate-spin" /> : (mode === 'transform' ? 'Transform' : 'Validate')}
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
