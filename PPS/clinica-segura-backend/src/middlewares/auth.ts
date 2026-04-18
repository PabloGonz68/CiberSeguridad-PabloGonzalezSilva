import { Request, Response, NextFunction } from 'express';
import { getSupabase } from '../supabase';

// 1. Autenticación: Validar el token de Supabase
export const checkAuth = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ error: 'Falta el token de autorización' });

  const token = authHeader.split(' ')[1];

  const { data: { user }, error } = await getSupabase().auth.getUser(token);
  if (error || !user) return res.status(401).json({ error: 'Token inválido o expirado' });

  // Obtenemos el perfil para saber su rol (RBAC) y si ha adoptado (ABAC)
  const { data: profile } = await getSupabase()
    .from('profiles')
    .select('role, has_adopted_pet')
    .eq('id', user.id)
    .single();

  // Guardamos la info del usuario en la request para las siguientes funciones
  (req as any).user = { ...user, ...(profile || {}) };
  next();
};

// 2. Autorización RBAC (Roles: admin, clientela, veterinario, ventas)
export const authorizeRole = (allowedRoles: string[]) => {
  return (req: Request, res: Response, next: NextFunction): any => {
    const user = (req as any).user;
    if (!user || !allowedRoles.includes(user.role)) {
      return res.status(403).json({ error: `Acceso denegado. Se requiere uno de estos roles: ${allowedRoles.join(', ')}` });
    }
    next();
  };
};

// 3. Autorización ABAC (Atributos: tiene que haber adoptado una mascota)
export const checkAdoptionBenefit = (req: Request, res: Response, next: NextFunction): any => {
  const user = (req as any).user;
  if (user.role === 'clientela' && !user.has_adopted_pet) {
    return res.status(403).json({ 
        error: 'Oferta bloqueada. Requisito: Debes haber adoptado una mascota para acceder a estos descuentos.' 
    });
  }
  next();
};