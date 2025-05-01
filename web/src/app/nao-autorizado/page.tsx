"use client"

import React from 'react';
import { useRouter } from "next/navigation"

const NaoAutorizado: React.FC = () => {
  const router = useRouter()

  const handleVoltar = () => {
    router.push('/');
  };

  return (
    <div style={styles.container}>
      <h1 style={styles.title}>Acesso Negado</h1>
      <p style={styles.message}>Você não tem permissão para acessar esta página.</p>
      <button style={styles.button} onClick={handleVoltar}>
        Voltar para a Página Inicial
      </button>
    </div>
  );
};

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'column' as const,
    alignItems: 'center',
    justifyContent: 'center',
    height: '100vh',
    textAlign: 'center' as const,
    backgroundColor: '#f8f9fa',
  },
  title: {
    fontSize: '2rem',
    color: '#dc3545',
    marginBottom: '1rem',
  },
  message: {
    fontSize: '1.2rem',
    color: '#6c757d',
    marginBottom: '2rem',
  },
  button: {
    padding: '0.5rem 1rem',
    fontSize: '1rem',
    color: '#fff',
    backgroundColor: '#007bff',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer',
  },
};

export default NaoAutorizado;