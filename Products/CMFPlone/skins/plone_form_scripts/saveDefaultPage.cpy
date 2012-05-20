## Script (Python) "selectDefaultPage"
##title=Helper method to select a default page for a folder view
##bind container=container
##bind context=context
##bind namespace=
##bind script=script
##bind state=state
##bind subpath=traverse_subpath
##parameters=objectId=None

from Products.CMFPlone import PloneMessageFactory as _

REQUEST = context.REQUEST
response = REQUEST.response

authenticator = context.restrictedTraverse('@@authenticator')
if not authenticator.verify():
    context.plone_utils.addPortalMessage(_(u'Support for setting default page via URL disabled.'), 'warning')
    view_select_url = context.absolute_url() + '/select_default_page'
    return response.redirect(view_select_url)


if not objectId:
    context.plone_utils.addPortalMessage(_(u'Please select an item to use.'), 'error')
    return state.set(status = 'missing')

if not objectId in context.objectIds():
    message = _(u'There is no object with short name ${name} in this folder.',
                mapping={u'name' : objectId})

    context.plone_utils.addPortalMessage(message, 'error')
    return state.set(status = 'failure')

context.setDefaultPage(objectId)

context.plone_utils.addPortalMessage(_(u'View changed.'))
return state
