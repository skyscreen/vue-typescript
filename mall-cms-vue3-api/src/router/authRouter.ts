import Router from '@koa/router'

import { verifyLogin, verifyAuth } from '@/middleware/verifyMiddleware'
import authController from '@/controller/auth/authController'

const authRouter = new Router()

authRouter.post('/login', verifyLogin, authController.login)
authRouter.get('/test', verifyAuth, authController.login)
// authRouter.get('/test1', verifyAuth, authController.success)


export default authRouter
