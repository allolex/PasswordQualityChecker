import React from "react"
import {useForm} from "react-hook-form"
import {yupResolver} from "@hookform/resolvers/yup"
import * as Yup from "yup"
import axios from "axios"

const apiHost = "localhost:3005"
// TODO: Change to https in production
const passwordCheckUrl = `http://${apiHost}/password_qa`

export default function App() {
    const validationSchema = Yup.object().shape({
        password: Yup.string()
            .required("Password is required")
            .test(
                "password-backend-validation",
                "Weak password",
                async (password, ctx) => {
                    if (!password) { return false }

                    const {data: {passed_qa, errors}} = await axios.post(
                        passwordCheckUrl,
                        {password: password},
                    )

                    if (errors) {
                        const passwordErrors = "The password you have selected is too weak. " + errors.password.join("; ")
                        return ctx.createError({ message: passwordErrors })
                    }

                    return passed_qa
                }
            )
    })

    const formOptions = {mode: "onChange", resolver: yupResolver(validationSchema)}

    const {register, handleSubmit, reset, formState} = useForm(formOptions)
    const {errors} = formState

    function onSubmit(data) {
        alert("Your password is strong!\n\n" + JSON.stringify(data, null, 4))
        return false
    }

    return (
        <div className="card m-3">
            <h5 className="card-header">Now select a password</h5>
            <div className="card-body">
                <form onSubmit={handleSubmit(onSubmit)}>
                    <div className="form-row">
                        <div className="form-group col">
                            <label>Password</label>
                            <input name="password" type="password" {...register("password")}
                                className={`form-control ${errors.password ? "is-invalid" : ""}`}/>
                            <div className="invalid-feedback">{errors.password?.message}</div>
                        </div>
                    </div>
                    <div className="form-group">
                        <button type="submit" className="btn btn-primary mr-1">Next</button>
                        <button type="button" onClick={() => reset()} className="btn btn-secondary">Reset</button>
                    </div>
                </form>
            </div>
        </div>
    )
}

export {App}