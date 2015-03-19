-- Copyright (c) Microsoft. All rights reserved.
-- Licensed under the MIT license. See LICENSE file in the project root for full license information.

{-# LANGUAGE OverloadedStrings, RecordWildCards, DeriveGeneric #-}

module Bond.Schema.JSON
    ( FromJSON(..)
    ) where

import Data.Aeson
import Control.Applicative
import Bond.Schema.Types

instance FromJSON Modifier
instance ToJSON Modifier

instance FromJSON Type where
    parseJSON (String "int8") = pure BT_Int8
    parseJSON (String "int16") = pure BT_Int16
    parseJSON (String "int32") = pure BT_Int32
    parseJSON (String "int64") = pure BT_Int64
    parseJSON (String "uint8") = pure BT_UInt8
    parseJSON (String "uint16") = pure BT_UInt16
    parseJSON (String "uint32") = pure BT_UInt32
    parseJSON (String "uint64") = pure BT_UInt64
    parseJSON (String "float") = pure BT_Float
    parseJSON (String "double") = pure BT_Double
    parseJSON (String "bool") = pure BT_Bool
    parseJSON (String "string") = pure BT_String
    parseJSON (String "wstring") = pure BT_WString
    parseJSON (String "bond_meta::name") = pure BT_MetaName
    parseJSON (String "bond_meta::full_name") = pure BT_MetaFullName
    parseJSON (String "blob") = pure BT_Blob
    parseJSON (Object o) = do
        type_ <- o .: "type"
        case type_ of
            String "maybe" -> BT_Maybe <$>
                o .: "element"
            String "list" -> BT_List <$>
                o .: "element"
            String "vector" -> BT_Vector <$>
                o .: "element"
            String "nullable" -> BT_Nullable <$>
                o .: "element"
            String "set" -> BT_Set <$>
                o .: "element"
            String "map" -> BT_Map <$>
                o .: "key" <*>
                o .: "element"
            String "bonded" -> BT_Bonded <$>
                o .: "element"
            String "constant" -> BT_IntTypeArg <$>
                o .: "value"
            String "parameter" -> BT_TypeParam <$>
                o .: "value"
            String "user" -> BT_UserDefined <$>
                o .: "declaration" <*>
                o .: "arguments"
            _ -> empty
    parseJSON _ = empty

instance ToJSON Type where
    toJSON BT_Int8 = "int8"
    toJSON BT_Int16 = "int16"
    toJSON BT_Int32 = "int32"
    toJSON BT_Int64 = "int64"
    toJSON BT_UInt8 = "uint8"
    toJSON BT_UInt16 = "uint16"
    toJSON BT_UInt32 = "uint32"
    toJSON BT_UInt64 = "uint64"
    toJSON BT_Float = "float"
    toJSON BT_Double = "double"
    toJSON BT_Bool = "bool"
    toJSON BT_String = "string"
    toJSON BT_WString = "wstring"
    toJSON BT_MetaName = "bond_meta::name"
    toJSON BT_MetaFullName = "bond_meta::full_name"
    toJSON BT_Blob = "blob"
    toJSON (BT_Maybe t) = object
        [ "type" .= String "maybe"
        , "element" .= t
        ]
    toJSON (BT_List t) = object
        [ "type" .= String "list"
        , "element" .= t
        ]
    toJSON (BT_Vector t) = object
        [ "type" .= String "vector"
        , "element" .= t
        ]
    toJSON (BT_Nullable t) = object
        [ "type" .= String "nullable"
        , "element" .= t
        ]
    toJSON (BT_Set t) = object
        [ "type" .= String "set"
        , "element" .= t
        ]
    toJSON (BT_Map k t) = object
        [ "type" .= String "map"
        , "key" .= k
        , "element" .= t
        ]
    toJSON (BT_Bonded t) = object
        [ "type" .= String "bonded"
        , "element" .= t
        ]
    toJSON (BT_IntTypeArg n) = object
        [ "type" .= String "constant"
        , "value" .= n
        ]
    toJSON (BT_TypeParam p) = object
        [ "type" .= String "parameter"
        , "value" .= p
        ]
    toJSON (BT_UserDefined decl args) = object
        [ "type" .= String "user"
        , "declaration" .= decl
        , "arguments" .= args
        ]

instance FromJSON Default
instance ToJSON Default

instance FromJSON Attribute
instance ToJSON Attribute

instance FromJSON Field
instance ToJSON Field

instance FromJSON Constant
instance ToJSON Constant

instance FromJSON Constraint where
    parseJSON (String "value") = pure Value
    parseJSON _ = empty

instance ToJSON Constraint where
    toJSON Value = "value"

instance FromJSON TypeParam
instance ToJSON TypeParam

instance FromJSON Declaration
instance ToJSON Declaration

instance FromJSON Import
instance ToJSON Import

instance FromJSON Language
instance ToJSON Language

instance FromJSON Namespace
instance ToJSON Namespace

instance FromJSON Bond
instance ToJSON Bond
