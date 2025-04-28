import axios from 'axios';
import Cookie from 'js-cookie';

// Criação de um cliente Axios
const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Adicionar interceptador de requisição
apiClient.interceptors.request.use(
  async (config) => {
    // Buscar o accessToken do cookie
    const accessToken = Cookie.get('accessToken');
    const userId = Cookie.get('userId');
    const fazendaId = Cookie.get('fazendaId');

    if (accessToken) {
      config.headers['Authorization'] = `Bearer ${accessToken}`;
    }

    if (userId) {
      config.headers['user-id'] = userId;
    }

    if (fazendaId) {
      config.headers['fazenda-id'] = fazendaId;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Adicionar interceptador de resposta para lidar com a renovação de token
apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    // Se o erro for 403, tentar renovar o token
    if (error.response?.status === 403) {
      const refreshToken = Cookie.get('refreshToken');
      
      if (refreshToken) {
        try {
          // Tentar renovar o accessToken com o refreshToken
          const refreshResponse = await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/auth/refresh`, {
            refreshToken,
          });

          const newAccessToken = refreshResponse.data.accessToken;
          Cookie.set('accessToken', newAccessToken, { expires: 1 });

          // Retentar a requisição original com o novo token
          error.config.headers['Authorization'] = `Bearer ${newAccessToken}`;
          return axios(error.config);
        } catch (refreshError) {
          // Se falhar, limpar os cookies e redirecionar para login
          Cookie.remove('accessToken');
          Cookie.remove('refreshToken');
          window.location.href = '/login';
          return Promise.reject(refreshError);
        }
      }
    }

    return Promise.reject(error);
  }
);

export default apiClient;
