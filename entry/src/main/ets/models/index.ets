export enum Type {
  name = 'name',
  email = 'email',
  birth = 'birth',
  gender = 'gender',
  signature = 'signature',
  number = 'number',
  password = 'password'
}

export interface TextType {
  title: string
  type: Type
}