import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const accessToken = request.cookies.get('accessToken');
  const selectedFarmId = request.cookies.get('selectedFarmId');

  const isAuth = !!accessToken;
  const hasSelectedFarm = !!selectedFarmId;

  const pathname = request.nextUrl.pathname;
  const isLoginPage = pathname === '/login';
  const isSelecionarFazendaPage = pathname === '/selecionar-fazenda';

  if (!isAuth && !isLoginPage) {
    const loginUrl = new URL('/login', request.url);
    return NextResponse.redirect(loginUrl);
  }

  if (isAuth && isLoginPage) {
    const homeUrl = new URL('/', request.url);
    return NextResponse.redirect(homeUrl);
  }

  if (isAuth && !hasSelectedFarm && !isSelecionarFazendaPage) {
    const selecionarFazendaUrl = new URL('/selecionar-fazenda', request.url);
    return NextResponse.redirect(selecionarFazendaUrl);
  }

  if (isAuth && hasSelectedFarm && isSelecionarFazendaPage) {
    const homeUrl = new URL('/', request.url);
    return NextResponse.redirect(homeUrl);
  }

  return NextResponse.next();
}

// Configurar as rotas que você quer que passem pelo middleware
export const config = {
  matcher: ['/((?!_next|favicon.ico).*)'], // aplica em tudo exceto _next e favicon
};
